--천정의 회귀
--카드군 번호: 0xcb0
function c81130130.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81130130.tg1)
	e1:SetOperation(c81130130.op1)
	c:RegisterEffect(e1)
end

--발동
function c81130130.filter0(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xcb0) and not c:IsCode(81130130)
end
function c81130130.filter1(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsFaceup()
end
function c81130130.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c81130130.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81130130.filter0,tp,0x20,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTODECK)
	local g1=Duel.SelectTarget(tp,c81130130.filter0,tp,0x20,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,2,0)
	if ct>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
end
function c81130130.cfilter(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xcb0)
end
function c81130130.op1(e,tp,eg,ep,ev,re,r,rp)
	local tg1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg1 or tg1:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then
		return
	end
	Duel.SendtoDeck(tg1,nil,0,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK)
		then Duel.ShuffleDeck(tp)
	end
	local ct=Duel.GetMatchingGroupCount(c81130130.filter1,tp,LOCATION_ONFIELD,LOCATION_MZONE,nil)
	local tg2=Duel.GetMatchingGroup(c81130130.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg3=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if ct>0 and #tg2>0 and #tg3>0 and Duel.SelectYesNo(tp,aux.Stringid(81130130,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=tg2:Select(tp,1,1,nil)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tc2=tg3:Select(tp,1,1,nil)
		Duel.Destroy(tc2,REASON_EFFECT)
	end
end
