--교화
function c47800028.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCountLimit(1,47800028)
	e1:SetCondition(c47800028.con1)
	e1:SetTarget(c47800028.tar1)
	e1:SetOperation(c47800028.op1)
	c:RegisterEffect(e1)
end
function c47800028.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800028.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47800028.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c47800028.tfil1(c)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN)
end
function c47800028.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c47800028.tfil1,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(c47800028.tfil1,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c47800028.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c47800028.tfil1,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		t=g:GetFirst()
		cre=t:GetCode()
		local token=Duel.CreateToken(tp,cre)
		Duel.SendtoHand(token,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,token)
	end
end