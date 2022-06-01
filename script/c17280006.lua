--티아라 퍼플
function c17280006.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,17280006)
	e1:SetCondition(c17280006.con1)
	e1:SetCost(c17280006.cost1)
	e1:SetTarget(c17280006.tg1)
	e1:SetOperation(c17280006.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c17280006.con2)
	e2:SetTarget(c17280006.tg2)
	e2:SetOperation(c17280006.op2)
	c:RegisterEffect(e2)
end
function c17280006.nfilter1(c)
	return c:IsSetCard(0x2c4) and c:IsFaceup()
end
function c17280006.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c17280006.nfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c17280006.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c17280006.tfilter1(c,e,tp)
	return c:IsSetCard(0x2c4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(17280006)
end
function c17280006.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17280006.tfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c17280006.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c17280006.tfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c17280006.con2(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c17280006.tfilter2(c,att)
	return c:IsSetCard(0x2c4) and c:IsAbleToHand() and c:IsAttribute(att) and not c:IsType(TYPE_SYNCHRO)
end
function c17280006.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local att=rc:GetOriginalAttribute()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17280006.tfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,att)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)
end
function c17280006.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local att=rc:GetOriginalAttribute()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATODECK)
	local g=Duel.SelectMatchingCard(tp,c17280006.tfilter2,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,att)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end