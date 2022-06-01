--전장의 위기(이글 유니온)
function c81170090.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81170090,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81170090+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81170090.tg)
	e1:SetOperation(c81170090.op)
	c:RegisterEffect(e1)
end

--act(search)
function c81170090.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsLevelBelow(5) and c:IsSetCard(0xcb4) and c:IsType(TYPE_MONSTER)
end
function c81170090.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc2=LOCATION_GRAVE+LOCATION_REMOVED
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81170090.filter2,tp,loc2,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81170090.filter2,tp,loc2,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81170090.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
