--미스크립틸테인
function c27182823.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCountLimit(1,27182823)
	e1:SetTarget(c27182823.tg1)
	e1:SetOperation(c27182823.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetOperation(c27182823.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetTarget(c27182823.tg3)
	e3:SetOperation(c27182823.op3)
	c:RegisterEffect(e3)
end
function c27182823.tfilter11(c)
	return c:IsSetCard(0x2c2)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToHand()
end
function c27182823.tfilter12(c)
	return c:IsSetCard(0x2c2)
		and c:IsAbleToGrave()
end
function c27182823.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and c27182823.tfilter11(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182823.tfilter11,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
			and Duel.IsExistingMatchingCard(c27182823.tfilter12,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27182823.tfilter11,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182823.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c27182823.tfilter12,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c27182823.ofilter2(c,att)
	return c:IsSetCard(0x2c2)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToDeck()
		and c:IsAttribute(att)
end
function c27182823.op2(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp and re:IsActiveType(TYPE_MONSTER) then
		local rc=re:GetHandler()
		local att=rc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c27182823.ofilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,att)
		if g:GetCount()>0 then
			Duel.Hint(HINT_CARD,0,27182823)
			Duel.HintSelection(g)
			if Duel.NegateActivation(ev) then
				if rc:IsRelateToEffect(re) then
					Duel.Destroy(rc,REASON_EFFECT)
				end
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		end
	end
end
function c27182823.tfilter3(c)
	return c:IsSetCard(0x2c2)
		and (c:IsFaceup()
			or c:IsLocation(LOCATION_GRAVE))
		and c:IsAbleToHand()
end
function c27182823.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
			and c27182823.tfilter3(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182823.tfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27182823.tfilter3,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27182823.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end