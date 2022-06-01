--举府胶 促农概磐
local m=18453021
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	WriteEff(e2,2,"NCO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,m+1)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.nfil2(c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil2,tp,"O",0,1,nil)
end
function cm.cfil2(c)
	return c:IsSetCard("举府胶") and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost() and not c:IsCode(m)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.cfil2,tp,"D",0,nil)
	if chk==0 then
		return g:GetClassCount(Card.GetCode)>2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,3,3)
	Duel.SendtoGrave(sg,REASON_COST)
	c:SetStatus(STATUS_EFFECT_ENABLED,true)
end
function cm.ofil2(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup() and c:IsHasExactSquareMana(ATTRIBUTE_DARK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTR("M",0)
	e1:SetTarget(cm.otar21)
	e1:SetValue(cm.oval21)
	Duel.RegisterEffect(e1,tp)
	local ct=0
	local dg=Duel.GMGroup(aux.disfilter1,tp,0,"O",nil)
	while ct<#dg do
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local sg=Duel.SMCard(tp,cm.ofil2,tp,"M",0,0,1,nil)
		local sc=sg:GetFirst()
		if sc then
			if ct<1 then
				Duel.BreakEffect()
			end
			ct=ct+1
			local e2=MakeEff(c,"S")
			e2:SetCode(EFFECT_SQUARE_MANA_DECLINE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(cm.oval22)
			sc:RegisterEffect(e2)
		else
			break
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local og=dg:Select(tp,ct,ct,nil)
	local oc=og:GetFirst()
	while oc do
		Duel.NegateRelatedChain(oc,RESET_TURN_SET)
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_DISABLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		oc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		oc:RegisterEffect(e4)
		oc=og:GetNext()
	end
end
function cm.otar21(e,c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE)
end
function cm.oval21(e,te)
	return e:GetOwnerPlayer()~=te:GetHandlerPlayer()
end
function cm.oval22(e,c)
	return ATTRIBUTE_DARK
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tfil3(c)
	return c:IsSetCard("举府胶") and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IETarget(cm.tfil3,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil3,tp,"G",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.ofil3(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		local sg=Duel.GMGroup(cm.ofil3,tp,"M",0,nil)
		local sc=sg:GetFirst()
		if sc then
			Duel.BreakEffect()
		end
		while sc do
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.oval22)
			sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
	end
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0xffff)
	e:SetLabel(att)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local att=e:GetLabel()
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
	e1:SetTR("M",0)
	e1:SetLabel(att)
	e1:SetTarget(cm.otar21)
	e1:SetValue(cm.oval41)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) then
		local e2=MakeEff(c,"FC","R")
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e2:SetCountLimit(1)
		e2:SetCondition(cm.ocon42)
		e2:SetOperation(cm.oop42)
		c:RegisterEffect(e2)
	end
end
function cm.oval41(e,c)
	return e:GetLabel()
end
function cm.ocon42(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocCount(tp,"S")>0 and c:IsSSetable()
end
function cm.oop42(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SSet(tp,c)
end