--트스래블드터백-식술도섬
function c18452899.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c18452899.condition)
	e1:SetTarget(c18452899.target)
	e1:SetOperation(c18452899.operation)
	c:RegisterEffect(e1)
end
function c18452899.cfilter(c)
	return c:GetSequence()<5
end
function c18452899.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c18452899.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18452899.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) and Duel.IsPlayerCanDiscardDeck(1-tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,0,0,PLAYER_ALL,2)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=3 then
		e:SetCategory(CATEGORY_DECKDES+CATEGORY_TOEXTRA)
	end
end
function c18452899.filter(c,tp)
	return c:GetSequence()>=5 and c:IsControler(1-tp) and c:IsAbleToDeck()
end
function c18452899.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetDecktopGroup(tp,2)
	local g2=Duel.GetDecktopGroup(1-tp,2)
	g1:Merge(g2)
	Duel.DisableShuffleCheck()
	if Duel.SendtoGrave(g1,REASON_EFFECT)~=0
		and g1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3
		and Duel.IsExistingMatchingCard(c18452899.filter,tp,0,LOCATION_MZONE,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(18452899,0)) then
		local g=Duel.GetMatchingGroup(c18452899.filter,tp,0,LOCATION_MZONE,nil,tp)
		Duel.DisableShuffleCheck(false)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
