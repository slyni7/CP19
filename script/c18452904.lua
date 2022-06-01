--논크캐샤-기도섬
function c18452904.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c18452904.condition)
	e1:SetTarget(c18452904.target)
	e1:SetOperation(c18452904.activate)
	c:RegisterEffect(e1)
end
function c18452904.cfilter(c)
	return c:GetSequence()<5
end
function c18452904.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c18452904.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18452904.filter(c,e,tp,spchk)
	return c:IsType(TYPE_MONSTER) and (c:IsAbleToRemove() or (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c18452904.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c18452904.filter(c,e,tp,spchk) end
	if chk==0 then return Duel.IsExistingTarget(c18452904.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,spchk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c18452904.filter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,spchk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,0,1-tp,LOCATION_GRAVE)
end
function c18452904.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (not tc:IsAbleToRemove() or Duel.SelectYesNo(tp,aux.Stringid(18452904,0))) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
