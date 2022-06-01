--Angel Notes - Ä­Å¸ºô·¹
function c76859118.initial_effect(c)
	c:SetUniqueOnField(1,0,76859118)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c76859118.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(76859118)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(76859168)
	e3:SetRange(LOCATION_DECK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c76859118.cost4)
	e4:SetTarget(c76859118.tg4)
	e4:SetOperation(c76859118.op4)
	c:RegisterEffect(e4)
end
function c76859118.op1(e,tp,eg,ep,ev,re,r,rp)
end
function c76859118.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function c76859118.tfilter4(c)
	return c:IsSetCard(0x2c8) and c:IsFaceup()
end
function c76859118.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc==0 then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c76859118.tfilter4(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c76859118.tfilter4,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c76859118.tfilter4,tp,LOCATION_MZONE,0,1,1,nil)
end
function c76859118.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(c76859118.oval41)
		tc:RegisterEffect(e1)
	end
end
function c76859118.oval41(e,te)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and not tc:IsSetCard(0x2c8)
end