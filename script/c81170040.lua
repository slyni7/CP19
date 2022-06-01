--USS 니콜라스
function c81170040.initial_effect(c)

	--atk inc.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81170040,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetCondition(c81170040.cn)
	e1:SetCost(c81170040.co)
	e1:SetTarget(c81170040.tg)
	e1:SetOperation(c81170040.op)
	c:RegisterEffect(e1)
	
	--dam dec.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFEC_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c81170040.val)
	c:RegisterEffect(e2)
end

--dam dec.
function c81170040.cn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c81170040.co(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsReleasable()
	end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c81170040.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcb4) and c:IsType(TYPE_MONSTER)
end
function c81170040.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and c81170040.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81170040.filter1,tp,LOCATION_MZONE,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81170040.filter1,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c81170040.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end

--dam dec.
function c81170040.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return math.ceil(dam/2)
	else
		return dam
	end
end


