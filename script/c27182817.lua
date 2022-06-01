--헤븐즈 스크립트
function c27182817.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_TUNER),7,2,c27182817.xfilter,aux.Stringid(27182817,15),2,c27182817.xop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCost(c27182817.cost1)
	e1:SetTarget(c27182817.tg1)
	e1:SetOperation(c27182817.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetTarget(c27182817.tg2)
	e2:SetOperation(c27182817.op2)
	c:RegisterEffect(e2)
end
function c27182817.xfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x22c2)
end
function c27182817.xofilter(c)
	return c:IsSetCard(0x2c2)
end
function c27182817.xop(e,tp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27182817.xofilter,tp,LOCATION_HAND,0,1,nil)
			and Duel.GetFlagEffect(tp,27182817)==0
	end
	Duel.RegisterFlagEffect(tp,27182817,RESET_PHASE+PHASE_END,0,1)
	local g=Duel.SelectMatchingCard(tp,c27182817.xofilter,tp,LOCATION_HAND,0,1,1,nil)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
	return true
end
function c27182817.cfilter1(c)
	return c:IsSetCard(0x12c2)
		and c:GetType()==TYPE_SPELL+TYPE_QUICKPLAY
		and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(false,true,true)~=nil
end
function c27182817.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
			and Duel.IsExistingMatchingCard(c27182817.cfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c27182817.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	local te=tc:GetActivateEffect()
	e:SetLabelObject(te)
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.SendtoGrave(g,REASON_COST)
end
function c27182817.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local te=e:GetLabelObject()
	local tg=te:GetTarget()
	if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else
		e:SetProperty(0)
	end
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c27182817.op1(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local op=te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c27182817.tfilter2(c)
	return c:IsSetCard(0x2c2)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToHand()
end
function c27182817.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and c2718217.tfilter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182817.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	local g=Duel.SelectTarget(tp,c27182817.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182817.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end