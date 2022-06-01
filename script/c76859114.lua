--Angel Notes - 애드리브
function c76859114.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetCountLimit(1,76859114+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c76859114.con1)
	e1:SetOperation(c76859114.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,76859115)
	e2:SetCost(c76859114.cost2)
	e2:SetCondition(c76859114.con2)
	e2:SetTarget(c76859114.tg2)
	e2:SetOperation(c76859114.op2)
	c:RegisterEffect(e2)
end
function c76859114.nfilter1(c)
	return c:IsSetCard(0x2c8) and c:IsFaceup()
end
function c76859114.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c76859114.nfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c76859114.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_ACTIVATING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(c76859114.oop11)
	Duel.RegisterEffect(e1,tp)
end
function c76859114.oop11(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if ep~=tp and loc&LOCATION_ONFIELD<1 then
		Duel.Hint(HINT_CARD,0,76859114)
		Duel.NegateEffect(ev)
	end
end
function c76859114.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c76859114.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c76859114.tfilter21(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER)
end
function c76859114.tfilter22(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x2c8) and c:IsType(TYPE_SPELL) and not c:IsCode(76859114)
end
function c76859114.tfilter23(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x2c8) and c:IsType(TYPE_TRAP)
end
function c76859114.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(c76859114.tfilter21,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingTarget(c76859114.tfilter22,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingTarget(c76859114.tfilter23,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c76859114.tfilter21,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c76859114.tfilter22,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=Duel.SelectTarget(tp,c76859114.tfilter23,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c76859114.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end