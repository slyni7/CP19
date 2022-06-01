--스로크즈저시-식술도섬
function c18452900.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c18452900.condition)
	e1:SetTarget(c18452900.target)
	e1:SetOperation(c18452900.activate)
	c:RegisterEffect(e1)
end
function c18452900.cfilter(c)
	return c:GetSequence()<5
end
function c18452900.thfilter(c,e,tp)
	return c:IsSetCard(0x12da) and c:IsLevel(4) and (c:IsAbleToHand() or (spchk and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c18452900.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c18452900.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18452900.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local spchk=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c18452900.thfilter(chkc,e,tp,spchk) end
	if chk==0 then return Duel.IsExistingTarget(c18452900.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,spchk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c18452900.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,spchk)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
end
function c18452900.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.SelectOption(tp,1190,1152)==1 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
