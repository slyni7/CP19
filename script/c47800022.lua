--생각 훔치기
function c47800022.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47800022+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c47800022.condition)
	e1:SetTarget(c47800022.target)
	e1:SetOperation(c47800022.activate)
	c:RegisterEffect(e1)
end
function c47800022.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800022.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=120 and Duel.IsExistingMatchingCard(c47800022.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
end
function c47800022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function c47800022.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK,nil)
	if g:GetCount()<2 then return end
	local dg=g:RandomSelect(tp,2)
	local t=dg:GetFirst()
	while t do
	local cre=t:GetCode()
	local token=Duel.CreateToken(tp,cre)
	Duel.SendtoHand(token,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
	t=dg:GetNext()
	end
	Duel.ShuffleDeck(1-tp)
end
