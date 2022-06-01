--Guilty Shou-ka
function c81110070.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81110070.acn)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c81110070.cn)
	e1:SetCost(c81110070.co)
	e1:SetTarget(c81110070.tg)
	e1:SetOperation(c81110070.op)
	c:RegisterEffect(e1)

	--grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81110070,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c81110070.vcn)
	e3:SetCost(c81110070.vco)
	e3:SetTarget(c81110070.vtg)
	e3:SetOperation(c81110070.vop)
	c:RegisterEffect(e3)
end

--activate
function c81110070.acn(e,c)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,7,nil,0xcae)
end

function c81110070.filter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp
	and c:IsPreviousSetCard(0xcae)
	and ( c:IsReason(REASON_BATTLE) or ( rp==1-tp and c:IsReason(REASON_EFFECT) ) )
end

function c81110070.cn(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81110070.filter,1,nil,tp,rp)
end
function c81110070.co(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81110070.dfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c81110070.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81110070.dfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c81110070.dfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c81110070.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81110070.dfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end

--grave
function c81110070.vcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c81110070.vco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToRemoveAsCost()
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c81110070.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xcae)
end
function c81110070.vtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c81110070.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81110070.filter2,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81110070.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81110070.vop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		tc:RegisterEffect(e1)
	end
end
