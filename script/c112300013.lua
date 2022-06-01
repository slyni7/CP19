--치고나가는 결사의 사슬
function c112300013.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,112300013+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c112300013.target)
	e1:SetOperation(c112300013.activate)
	c:RegisterEffect(e1)
end
function c112300013.filter1(c,e,tp)
	return c:IsRace(RACE_PSYCHO) and Duel.IsExistingMatchingCard(c112300013.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c112300013.filter2(c,e,tp,lv)
	return c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_TUNER) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c112300013.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c:GetLevel()==e:GetLabel() end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112300013.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c112300013.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c112300013.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local code=tc:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c112300013.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false)
		end
	end
end