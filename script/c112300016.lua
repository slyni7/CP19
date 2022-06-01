--앞서나가는 용맹의 성단
function c112300016.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,112300016+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c112300016.target)
	e1:SetOperation(c112300016.activate)
	c:RegisterEffect(e1)
end
function c112300016.desfilter(c)
	return c:IsRace(RACE_PSYCHO) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
end
function c112300016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c112300016.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c112300016.desfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end
function c112300016.activate(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end