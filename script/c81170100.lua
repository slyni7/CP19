--USS 펜사콜라
function c81170100.initial_effect(c)

	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81170100,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,81170100)
	e1:SetCondition(c81170100.cn)
	e1:SetTarget(c81170100.tg)
	e1:SetOperation(c81170100.op)
	c:RegisterEffect(e1)
	
	--atk dec.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81170100,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1)
	e2:SetCondition(c81170100.ecn)
	e2:SetTarget(c81170100.etg)
	e2:SetOperation(c81170100.eop)
	c:RegisterEffect(e2)
end

--salvage
function c81170100.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81170100.filter1(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0xcb4)
end
function c81170100.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c81170100.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81170100.filter1,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81170100.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81170100.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--dec.
function c81170100.ecn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c81170100.filter2(c)
	return c:IsFaceup() and c:IsPosition(POS_FACEUP_ATTACK)
end
function c81170100.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c81170100.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81170100.filter2,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81170100.filter2,tp,0,LOCATION_MZONE,1,1,nil)
end
function c81170100.eop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
