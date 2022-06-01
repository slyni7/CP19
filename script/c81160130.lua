--그림자무리의 악몽
--카드군 번호: 0xcb3
function c81160130.initial_effect(c)

	--todeck
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81160130+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81160130.tg1)
	e1:SetOperation(c81160130.op1)
	c:RegisterEffect(e1)
	
	--SSet
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81160130,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c81160130.co2)
	e2:SetTarget(c81160130.tg2)
	e2:SetOperation(c81160130.op2)
	c:RegisterEffect(e2)
end

--todeck
function c81160130.filter0(c)
	return c:IsAbleToDeck() and c:IsFaceup() and c:IsSetCard(0xcb3) and c:IsType(TYPE_MONSTER)
end
function c81160130.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return c:IsLocation(LOCATION_REMOVED) and c:IsControler(tp) and c81160130.filter0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81160130.filter0,tp,LOCATION_REMOVED,0,3,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81160130.filter0,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c81160130.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c81160130.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g or g:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then
		return
	end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		Duel.ShuffleDeck(tp)
		local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local mg=Duel.GetMatchingGroup(c81160130.filter2,tp,LOCATION_GRAVE,0,nil,e,tp)
		if ct==3 and mg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.SelectYesNo(tp,aux.Stringid(81160130,0)) then
			Duel.BreakEffect()
			local sg=mg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--SSet
function c81160130.cfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xcb3)
end
function c81160130.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81160130.cfilter,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81160130.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81160130.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSSetable()
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function c81160130.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	Duel.SSet(tp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
end


