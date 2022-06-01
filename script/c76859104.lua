--Angel Notes - 무브먼트
function c76859104.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,76859104+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c76859104.cost1)
	e1:SetTarget(c76859104.tg1)
	e1:SetOperation(c76859104.op1)
	c:RegisterEffect(e1)
end
function c76859104.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c76859104.tfilter41(c,e,tp)
	return c:IsSetCard(0x2c8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859104.tfilter42(c)
	return c:IsSetCard(0x2c8) and c:IsSSetable() and not c:IsType(TYPE_FIELD) and not c:IsCode(76859104)
end
function c76859104.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c76859104.tfilter41,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(c76859104.tfilter42,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859104.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c76859104.tfilter41,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if #g1>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g2=Duel.SelectMatchingCard(tp,c76859104.tfilter42,tp,LOCATION_DECK,0,1,1,nil)
		if #g2>0 then
			local tc=g2:GetFirst()
			Duel.SSet(tp,tc)
			if tc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			elseif tc:IsType(TYPE_TRAP) then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
		end
	end
end