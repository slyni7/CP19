--스크립트와일라잇
function c27182822.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCountLimit(1)
	e1:SetTarget(c27182822.tg1)
	e1:SetOperation(c27182822.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetTarget(c27182822.tg2)
	e2:SetOperation(c27182822.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCondition(c27182822.con3)
	e3:SetCost(c27182822.cost3)
	e3:SetTarget(c27182822.tg3)
	e3:SetOperation(c27182822.op3)
	c:RegisterEffect(e3)
end
function c27182822.tfilter1(c)
	return c:IsSetCard(0x2c2)
		and c:IsAbleToGrave()
		and not c:IsCode(27182822)
end
function c27182822.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27182822.tfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c27182822.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c27182822.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c27182822.tfilter2(c)
	return c:IsSetCard(0x2c2)
		and c:IsType(TYPE_MONSTER)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToHand()
end
function c27182822.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and c27182822.tfilter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182822.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	local g=Duel.SelectTarget(tp,c27182822.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182822.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c27182822.con3(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)
end
function c27182822.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
			and Duel.IsExistingTarget(c27182822.tfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c)
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c27182822.tfilter3(c)
	return c:IsSetCard(0x2c2)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToDeck()
end
function c27182822.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and c27182822.tfilter3(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182822.tfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	local g=Duel.SelectTarget(tp,c27182822.tfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182822.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end