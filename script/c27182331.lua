--루드라의 다원마도서
function c27182331.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e2:SetCountLimit(1,27182331+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c27182331.tar2)
	e2:SetOperation(c27182331.op2)
	c:RegisterEffect(e2)
end
function c27182331.tfil2(c)
	return (c:IsSetCard(0x306e) or (c:IsRace(RACE_SPELLCASTER) and c:IsLocation(LOCATION_MZONE))) and c:IsAbleToGrave() and not c:IsCode(27182331)
end
function c27182331.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27182331.tfil2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c27182331.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c27182331.tfil2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.Draw(tp,2,REASON_EFFECT)
end