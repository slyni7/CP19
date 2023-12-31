--°¡Á¬Æ® º¹½º
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTR("HM",0)
	e2:SetD(id,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,"°¡Á¬Æ®"))
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","S")
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function s.ofil1(c)
	return c:IsSetCard("°¡Á¬Æ®") and c:IsRace(RACE_ILLUSION) and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.ofil1,tp,"D",0,0,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.tfil3(c)
	return c:IsSetCard("°¡Á¬Æ®") and c:IsFaceup()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and chkc:IsControler(tp) and s.tfil3(chkc)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil3,tp,"M",0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	Duel.STarget(tp,s.tfil3,tp,"M",0,2,2,nil)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetTargetCards(e):Filter(Card.IsFaceup,nil)
	if #g~=2 then
	end
	local tc=g:GetFirst()
	while tc do
		local b1=true
		local b2=tc:IsLevelAbove(2)
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,1)},
			{b2,aux.Stringid(id,2)})
		local value=(op==2 and -2) or 2
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(value)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end