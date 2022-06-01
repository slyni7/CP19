--SQLite
function c27182800.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27182800.tg1)
	e1:SetOperation(c27182800.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,27182800)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCost(c27182800.cost2)
	e2:SetTarget(c27182800.tg2)
	e2:SetOperation(c27182800.op2)
	c:RegisterEffect(e2)
end
function c27182800.tfilter1(c)
	return c:IsSetCard(0x2c2)
end
function c27182800.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27182800.tfilter1,tp,LOCATION_HAND,0,1,c)
			and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c27182800.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c27182800.tfilter1,tp,LOCATION_HAND,0,1,nil) then
		Duel.DiscardHand(tp,c27182800.tfilter1,1,1,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.Draw(tp,2,REASON_EFFECT)
end
function c27182800.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c27182800.tfilter2(c)
	return c:IsSetCard(0x2c2) and c:IsAbleToHand()
end
function c27182800.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27182800.tfilter1,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(c27182800.tfilter2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27182800.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c27182800.tfilter1,tp,LOCATION_HAND,0,1,nil) then
		Duel.DiscardHand(tp,c27182800.tfilter1,1,1,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27182800.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end