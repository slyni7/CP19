--탐욕의 지명자
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetD(id,0)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","M")
	e3:SetCode(EVENT_CHAIN_SOLVED)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
end
function s.tfil1(c)
	return c:IsSetCard("지명자") and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsSetCard("지명자") and rc:IsStatus(STATUS_ACT_FROM_HAND) and rc:IsFaceup()
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsStatus(STATUS_LEAVE_CONFIRMED) and rp==tp then
		Duel.Hint(HINT_CARD,0,id)
		rc:CancelToGrave()
		Duel.ChangePosition(rc,POS_FACEDOWN) 
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+RESETS_CANNOT_ACT+RESET_PHASE+PHASE_END)
		rc:RegisterEffect(e1)
	end
end