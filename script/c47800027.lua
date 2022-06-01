--생각 삼키기
function c47800027.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47800027+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c47800027.condition)
	e1:SetTarget(c47800027.target)
	e1:SetOperation(c47800027.activate)
	c:RegisterEffect(e1)
end
function c47800027.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800027.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=120 and Duel.IsExistingMatchingCard(c47800027.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2
end
function c47800027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,1)
end
function c47800027.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK,nil)
	if g:GetCount()<3 then return end
	local dg=g:RandomSelect(tp,3)
	local t=dg:GetFirst()
	while t do
	local cre=t:GetCode()
	local token=Duel.CreateToken(tp,cre)
	Duel.SendtoDeck(token,tp,0,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,token)
	t=dg:GetNext()
	end
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
end