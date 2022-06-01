--도로보네코 액티브
local m=18453147
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.pfun1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"A")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetSpeed(2)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	if not cm.global_effect then
		cm.global_effect=true
		local ge1=MakeEff(c,"F")
		ge1:SetCode(EFFECT_CAPABLE_CHANGE_POSITION)
		ge1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetTR("S","S")
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,m))
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.pfun1(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==#g
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0 and c:IsSSetable(true)
	end
	Duel.SSet(tp,c)
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x2e4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and aux.disfilter1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(aux.disfilter1,tp,"O","O",1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,aux.disfilter1,tp,"O","O",1,1,nil)
	Duel.SOI(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLoc("S") and c:IsFacedown() and c:GetType()==TYPE_TRAP and not c:IsStatus(STATUS_SET_TURN)
end
function cm.tfil3(c)
	return c:IsSetCard(0x2e4) and c:IsType(TYPE_MONSTER) and c:IsSSetable(true) and not c:IsCode(m)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GMGroup(cm.tfil3,tp,"G",0,nil)
	local ft=Duel.GetLocCount(tp,"S")
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil3(chkc)
	end
	if chk==0 then
		return ft>0 and #g>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	Duel.SetTargetCard(sg)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocCount(tp,"S")
	if #g<1 or ft<1 then
	end
	if #g>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		g=g:Select(tp,ft,ft,nil)
	end
	Duel.SSet(tp,g)
end