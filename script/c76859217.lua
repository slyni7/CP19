--레고 스타
function c76859217.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76859217+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c76859217.tg1)
	e1:SetOperation(c76859217.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,76859218)
	e2:SetCost(c76859217.cost2)
	e2:SetCondition(c76859217.con2)
	e2:SetTarget(c76859217.tg2)
	e2:SetOperation(c76859217.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(c76859217.tg3)
	e3:SetValue(c76859217.val3)
	e3:SetOperation(c76859217.op3)
	c:RegisterEffect(e3)
end
function c76859217.tfilter1(c)
	return c:IsSetCard(0x2ca) and c:IsAbleToHand() and not c:IsCode(76859217)
end
function c76859217.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859217.tfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859217.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859217.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c76859217.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardbale,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c76859217.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST)
end
function c76859217.tfilter2(c)
	return c:IsSetCard(0x2ca) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c76859217.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c76859217.tfilter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c76859217.tfilter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c76859217.tfilter2,tp,LOCATION_GRAVE,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c76859217.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c76859217.tfilter3(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:GetDestination()==LOCATION_GRAVE and c:IsSetCard(0x2ca) and c:IsReason(REASON_COST)
end
function c76859217.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost() and eg:IsExists(c76859217.tfilter3,1,nil,tp)
	end
	return Duel.SelectYesNo(tp,aux.Stringid(76859217,0))
end
function c76859217.val3(e,c)
	local tp=e:GetHandlerPlayer()
	return c76859217.tfilter3(c,tp)
end
function c76859217.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoGrave(c,REASON_COST)
end