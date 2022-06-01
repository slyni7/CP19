--어째서 내가 미술과에!?
local m=112603140
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--fusion material
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_FUSION_MATERIAL)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetCondition(cm.con1)
	e10:SetOperation(cm.op1)
	c:RegisterEffect(e10)
	aux.AddContactFusionProcedure(c,cm.pfil1,LOCATION_ONFIELD+LOCATION_GRAVE,0,Duel.Remove,POS_FACEUP,REASON_COST)
	--spsummon condition
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE)
	e100:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e100:SetCode(EFFECT_SPSUMMON_CONDITION)
	e100:SetValue(cm.splimit)
	c:RegisterEffect(e100)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCost(cm.rmcost)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	--pendulum
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCountLimit(1,c:GetOriginalCode())
	e1:SetTarget(cm.dbtg)
	e1:SetOperation(cm.dbop)
	c:RegisterEffect(e1)
end

cm.CardType_kiniro=true

--MAX HYPER UP THE END
cm.fusion_materials={112603130,112603132,112603134,112603136,112603138}
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
	if #mg<5 then
		return false
	end
	local count=0
	for i=1,5 do
		if mg:IsExists(Card.IsCode,1,nil,cm.fusion_materials[i]) then
			count=count+1
		end
	end
	if sub and mg:IsExists(Card.CheckFusionSubstitute,1,nil,c) then
		count=count+1
	end
	if count<5 then
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
	for i=1,5 do
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

--spsummon condition
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

--spsummon
function cm.spfilter(c,e,tp)
	return c:GetBaseAttack()==500 and c:IsRace(RACE_CYBERSE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--remove
function cm.rmcfilter(c,g)
	return g:IsContains(c)
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.rmcfilter,1,nil,lg) end
	local g=Duel.SelectReleaseGroup(tp,cm.rmcfilter,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

--pendulum
function cm.dbfilter(c)
	return c:IsCode(m+2) and c:IsAbleToHand()
end
function cm.dbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 
		then return Duel.IsExistingMatchingCard(cm.dbfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.dbop(e,tp,eg,ep,ev,re,r,rp)
	--pendulum
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
		if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
	--search
	local tc=Duel.GetFirstMatchingCard(cm.dbfilter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end