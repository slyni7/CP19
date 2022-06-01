--마음의 눈
function c47800021.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47800021+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c47800021.condition)
	e1:SetTarget(c47800021.target)
	e1:SetOperation(c47800021.activate)
	c:RegisterEffect(e1)
end
function c47800021.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=120 and Duel.IsExistingMatchingCard(c47800021.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
end
function c47800021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function c47800021.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local dg=g:RandomSelect(tp,1)
	local t=dg:GetFirst():GetCode()
	local token=Duel.CreateToken(tp,t)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
end