--EDM ·¹ÀÌ
function c29160029.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetDescription(1160)
	e0:SetTarget(c29160029.target)
	e0:SetOperation(c29160029.activate)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29160029,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29160029)
	e1:SetCost(c29160029.spcost1)
	e1:SetTarget(c29160029.sptg1)
	e1:SetOperation(c29160029.spop1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29160029,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE)
	e2:SetCountLimit(1,26077388)
	e2:SetCondition(c29160029.spcon2)
	e2:SetTarget(c29160029.sptg2)
	e2:SetOperation(c29160029.spop2)
	c:RegisterEffect(e2)
end
function c29160029.filter(c)
	return c:IsSetCard(0x2c7) and c:IsAbleToHand() and not c:IsCode(29160029)
end
function c29160029.drfilter(c)
	return c:IsSetCard(0x2c7) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
end
function c29160029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29160029.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(c29160029.drfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)>=3 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	end
end
function c29160029.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29160029.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT+REASON_DESTROY)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,1)
			and Duel.GetMatchingGroupCount(c29160029.drfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)>=3
			and Duel.SelectYesNo(tp,aux.Stringid(29160029,0)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c29160029.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsReleasable()
	end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c29160029.spfilter1(c,e,tp,ec)
	local sumtype=0
	if c:IsType(TYPE_LINK) then
		sumtype=SUMMON_TYPE_LINK
	end
	return c:IsSetCard(0x2c7) and c:IsCanBeSpecialSummoned(e,sumtype,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0
end
function c29160029.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c29160029.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c29160029.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29160029.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	local compro=false
	if tc:GetType()&TYPE_LINK>0 then
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		compro=true
	else
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	if tc:GetType()&TYPE_XYZ>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCondition(c29160029.rcon)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,false)
	end
	Duel.SpecialSummonComplete()
	if compro then
		tc:CompleteProcedure()
	end
end
function c29160029.rcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)>0 and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_XYZ) and re:GetHandler()==e:GetHandler() and ev<4
end
function c29160029.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
		and c:IsPreviousSetCard(0x2c7)
end
function c29160029.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29160029.cfilter,1,nil,tp)
end
function c29160029.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return ((not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
			or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0))
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c29160029.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
