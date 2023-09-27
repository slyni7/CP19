--레인보우 드라코스트
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STf")
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(s.con2)
	e2:SetValue(s.val2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S","M")
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(s.con2)
	e3:SetValue(1)
	c:RegisterEffect(e3)
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
	end
end
function s.ofil1(c,typ)
	return not c:IsType(typ) and c:IsAbleToHand() and c:IsSpellTrap()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,s.ofil1,tp,"G",0,1,1,nil,tc:GetType()&0x7)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function s.con2(e)
	local c=e:GetHandler()
	local re=c:GetReasonEffect()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL) and re
		and (re:GetHandler():GetOriginalRace()&RACE_WYRM~=0 or re:GetHandler():GetOriginalType()&TYPE_SPELL+TYPE_TRAP~=0)
end
function s.val2(e,te,tp)
	local c=e:GetHandler()
	local re=c:GetReasonEffect()
	return e:GetHandler()~te:GetHandler() and not te:IsActiveType(re:GetHandler():GetOriginalType()&0x7)
end