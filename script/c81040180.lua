--yatagarasu dynamo

function c81040180.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81040180+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81040180.acttg)
	e1:SetOperation(c81040180.actop)
	c:RegisterEffect(e1)
	
end

function c81040180.acttgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca4)
	and ( ( c:IsLocation(LOCATION_MZONE) and c:IsFaceup() ) or c:IsLocation(LOCATION_DECK) )
end
function c81040180.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c81040180.acttgfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil)
	end
	local g=Duel.GetMatchingGroup(c81040180.acttgfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,g,1,0,0)
	end
end
function c81040180.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81040180.acttgfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,2,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end