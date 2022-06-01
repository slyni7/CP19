--사피론 스톰
function c47500009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--Negate+damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_NEGATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,47500009)
	e2:SetCondition(c47500009.con)
	e2:SetTarget(c47500009.tar)
	e2:SetOperation(c47500009.op)
	c:RegisterEffect(e2)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,47500109)
	e4:SetCondition(c47500009.condition)
	e4:SetTarget(c47500009.target)
	e4:SetOperation(c47500009.operation)
	c:RegisterEffect(e4)
end
function c47500009.cfilter(c,tp)
	return c:IsSetCard(0x475) and c:IsFaceup()
end
function c47500009.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47500009.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c47500009.filter(c,e,tp)
	return not c:IsDisabled() and c:IsFaceup()
end
function c47500009.tar(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c47500009.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c47500009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c47500009.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c47500009.op(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()

	if not c:IsRelateToEffect(e) then return end

	if tc:IsRelateToEffect(e) and tc and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	if not (tc and tc:IsFaceup()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.GetMatchingGroup(c47500009.filter,tc,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(47500009,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local gc=g2:Select(tp,1,1,nil)
			Duel.HintSelection(gc)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			gc:GetFirst():RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetValue(RESET_TURN_SET)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			gc:GetFirst():RegisterEffect(e4)
			if gc:GetFirst():IsType(TYPE_TRAPMONSTER) then
				local e5=Effect.CreateEffect(c)
				e5:SetType(EFFECT_TYPE_SINGLE)
				e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e5:SetReset(RESET_EVENT+RESETS_STANDARD)
				gc:GetFirst():RegisterEffect(e5)
			end
		end
	else
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
function c47500009.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c47500009.filterq(c,e,tp)
	return c:IsSetCard(0x475) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47500009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47500009.filterq,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c47500009.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47500009.filterq,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end