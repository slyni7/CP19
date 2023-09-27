--나랑드라코스트
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STf")
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STf")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCL(1,{id,1})
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	if r&REASON_COST==0 or not re then
		return false
	end
	return (re:GetActivateLocation()&LSTN("O")~=0 or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and rp==tp
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return false
	end
	if chk==0 then
		return true
	end
	local rc=re:GetHandler()
	if rc:IsLoc("OGR") and rc:IsFaceup() then
		Duel.SetTargetCard(rc)
		Duel.SOI(0,CATEGORY_TOHAND,rc,2,tp,"G")
	else
		Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"G")
	end
end
function s.ofil1(c)
	return c:IsSetCard("드라코스트") and c:IsMonster() and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.ofil1,tp,"G",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.ofil2(c)
	return c:IsSSetable() and c:IsCode(38120068)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,s.ofil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end