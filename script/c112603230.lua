--BLiTz(블리츠) Ż 커큘러스 디 엔드
local m=112603230
local cm=_G["c"..m]
function cm.initial_effect(c)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)
	
	--immune
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetValue(cm.efilter)
	c:RegisterEffect(e10)
	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.negcon)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	
	--to deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
	
	--boost
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,3))
	e7:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetOperation(cm.atkop)
	c:RegisterEffect(e7)
	
	--MAX HYPER UP THE END
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	aux.AddContactFusionProcedure(c,cm.pfil1,LOCATION_ONFIELD,0,Duel.Remove,POS_FACEUP,REASON_COST)
	
end

cm.CardType_kiniro=true

--MAX HYPER UP THE END
cm.fusion_materials={112603205,112603206,112603207,112603214,112603215,112603216,112603217,112603218,112603226,112603227,112603228}
function cm.con1(e,g,gc,chkfnf)
	if g==nil then
		return insf and Auxiliary.MustMaterialCheck(nil,e:GetHandlerPlayer(),EFFECT_MUST_BE_FMATERIAL)
	end
	local c=e:GetHandler()
	local tp=c:GetControler()
	local notfusion=chkfnf&0x100>0
	local concat_fusion=chkfnf&0x200>0
	local sub=(sub or notfusion) and not concat_fusion
	local mg=g:Filter(cm.nfil11,c,c,sub,concat_fusion)
	if #mg<11 then
		return false
	end
	local count=0
	for i=1,11 do
		if mg:IsExists(Card.IsCode,1,nil,cm.fusion_materials[i]) then
			count=count+1
		end
	end
	if sub and mg:IsExists(Card.CheckFusionSubstitute,1,nil,c) then
		count=count+1
	end
	if count<11 then
		return false
	end
	if gc then
		if not mg:IsContains(gc) then
			return false
		end
		Duel.SetSelectedCard(Group.FromCards(gc))
	end
	local sg=Group.CreateGroup()
	return mg:IsExists(cm.nfil12,1,nil,tp,c,sub,chkfnf,mg,sg,table.unpack(cm.fusion_materials))
end
function cm.nfil11(c,fc,sub,concat_fusion)
	local fusion_type=concat_fusion and SUMMON_TYPE_SPECIAL or SUMMON_TYPE_FUSION
	if not c:IsCanBeFusionMaterial(fc,fusion_type) then
		return false
	end
	return c:IsFusionCode(table.unpack(cm.fusion_materials)) or (sub and c:CheckFusionSubstitute(fc))
end
function cm.nfil12(c,tp,fc,sub,chkfnf,mg,sg,...)
	local t={...}
	if t[2] then
		sg:AddCard(c)
		local res=false
		for i=1,#t do
			if c:IsFusionCode(t[i]) then
				local codes={...}
				table.remove(codes,i)
				res=mg:IsExists(cm.nfil12,1,sg,tp,fc,sub,chkfnf,mg,sg,table.unpack(codes))
			end
			if res then
				break
			end
		end
		sg:RemoveCard(c)
		return res
	else
		local chkf=chkfnf&0xff
		local concat_fusion=chkfnf&0x200>0
		sg:AddCard(c)
		local res=(concat_fusion or not sg:IsExists(Auxiliary.TuneMagicianCheckX,1,nil,sg,EFFECT_TUNE_MAGICIAN_F))
			and (c:IsFusionCode(t[1]) or (sub and c:CheckFusionMaterial(fc)))
			and (chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(tp,tp,sg,fc))
		sg:RemoveCard(c)
		return res
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local notfusion=chkfnf&0x100>0
	local concat_fusion=chkfnf&0x200>0
	local sub=(sub or notfusion) and not concat_fusion
	local mg=eg:Filter(cm.nfil11,c,c,sub,concat_fusion)
	if gc then
		Duel.SetSelectedCard(Group.FromCards(gc))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local sg=Group.CreateGroup()
	local codes=cm.fusion_materials
	for i=1,11 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local tg=mg:FilterSelect(tp,cm.nfil12,1,1,sg,tp,c,sub,chkfnf,mg,sg,table.unpack(codes))
		local tc=tg:GetFirst()
		sg:AddCard(tc)
		for i=1,#codes do
			if tc:IsFusionCode(codes[i]) then
				table.remove(codes,i)
				break
			end
		end
	end
	Duel.SetFusionMaterial(sg)
end
function cm.pfil1(c,fc)
	return (c:IsFusionCode(table.unpack(cm.fusion_materials)) or (sub and c:CheckFusionSubstitute(fc))) and c:IsAbleToRemoveAsCost()
end

--remove
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,aux.ExceptThisCard(e))
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end

--immune
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

--negate
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return not re:GetHandler():IsCode(m) and Duel.IsChainNegatable(ev)
end

function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end

--to deck
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

--boost
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(5000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end

--this is not xyz monster
	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_kiniro then
		return bit.bor(type(c),TYPE_XYZ)-TYPE_XYZ
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_kiniro then
		return bit.bor(otype(c),TYPE_XYZ)-TYPE_XYZ
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_kiniro then
		return bit.bor(ftype(c),TYPE_XYZ)-TYPE_XYZ
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_kiniro then
		return bit.bor(ptype(c),TYPE_XYZ)-TYPE_XYZ
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_kiniro then
		if t==TYPE_XYZ then
			return false
		end
		return itype(c,bit.bor(t,TYPE_XYZ)-TYPE_XYZ)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_kiniro then
		if t==TYPE_XYZ then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_XYZ)-TYPE_XYZ)
	end
	return iftype(c,t)
end
