--사피론 베일
function c47500010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--- Silk_hat_SET
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,47500010)
	e2:SetCondition(c47500010.con)
	e2:SetTarget(c47500010.tar)
	e2:SetOperation(c47500010.op)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,47500110)
	e4:SetCondition(c47500010.condition)
	e4:SetTarget(c47500010.target)
	e4:SetOperation(c47500010.operation)
	c:RegisterEffect(e4)
end

function c47500010.cfilter(c,tp)
	return c:IsSetCard(0x475) and c:IsFaceup()
end

function c47500010.setfilter(c)
	return c:IsCode(81210420) and c:IsSSetable()
end

function c47500010.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47500010.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c47500010.tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c47500010.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47500010.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c47500010.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c47500010.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c47500010.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local tc=Duel.GetFirstTarget()

	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c47500010.setfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local stc=g:GetFirst()
	if stc then
		Duel.SSet(tp,stc)
		Duel.ConfirmCards(1-tp,stc)
		
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		stc:RegisterEffect(e1)
	end

	if tc:IsRelateToEffect(e) then
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
	end
end

function c47500010.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c47500010.filterq(c,e,tp)
	return c:IsSetCard(0x475) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47500010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47500010.filterq,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47500010.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47500010.filterq,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end