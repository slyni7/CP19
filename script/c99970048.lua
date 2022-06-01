--RedHood: Origin
function c99970048.initial_effect(c)

	--서치
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(c99970048.target)
	e0:SetOperation(c99970048.activate)
	c:RegisterEffect(e0)
	
	--서치2
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,99970048)
	e1:SetCost(c99970048.cost)
	e1:SetTarget(c99970048.tg)
	e1:SetOperation(c99970048.op)
	c:RegisterEffect(e1)
	
end

--서치
function c99970048.filter(c)
	return c:IsSetCard(0xd34) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970048.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970048.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99970048.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--서치 2
function c99970048.thfilter(c)
	return c:IsSetCard(0xd34) and c:IsAbleToHand()
end
function c99970048.cfilter(c)
	return c:IsSetCard(0xd34) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost() and (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or c:IsFaceup())
end
function c99970048.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970048.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c99970048.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,2,2,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c99970048.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970048.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970048.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c99970048.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end



--옛날 옛날에 빨간 두건을 쓴 소녀가 있었습니다.
