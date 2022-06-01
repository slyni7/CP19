--심리 조작
function c47800023.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,47800023+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c47800023.condition)
	e1:SetTarget(c47800023.target)
	e1:SetOperation(c47800023.activate)
	c:RegisterEffect(e1)
end
function c47800023.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800023.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=120 and Duel.IsExistingMatchingCard(c47800023.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(c47800023.filters,tp,0,LOCATION_DECK,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c47800023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,1)
end
function c47800023.filters(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c47800023.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c47800023.filters,1-tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()==0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local dg=g:RandomSelect(tp,1)
	local t=dg:GetFirst()
	local token=Duel.CreateToken(tp,t:GetCode())
	Duel.SpecialSummon(token,0,tp,tp,true,false,POS_FACEUP)
	Duel.ShuffleDeck(1-tp)
end
