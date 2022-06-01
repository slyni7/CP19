--Melodevil Notes Divace
function c81150090.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81150090,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--continuous effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81150090,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,81150090)
	e2:SetCondition(c81150090.cn)
	e2:SetCost(c81150090.co)
	e2:SetTarget(c81150090.tg)
	e2:SetOperation(c81150090.op)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(81150090)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c81150090.tar4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c81150090.op5)
	c:RegisterEffect(e5)
end

--effect
function c81150090.cn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c81150090.filter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsSetCard(0xcb2)
end
function c81150090.co(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81150090.filter,tp,LOCATION_ONFIELD,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81150090.filter,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81150090.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81150090.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and  
	Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetValue(c81150090.lim)
		e1:SetLabel(re:GetHandler():GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c81150090.lim(e,re,tp)
	return ( re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or re:IsHasType(EFFECT_TYPE_ACTIVATE) )
	and re:GetHandler():IsCode(e:GetLabel())
end

--immune
function c81150090.tar4(e,c)
	return c:IsSetCard(0xcb2) and c:IsType(TYPE_LINK)
end

function c81150090.ofil5(c)
	return c:IsSetCard(0xcb2) and c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsHasEffect(81150090) and c:GetFlagEffect(81150090)==0
end
function c81150090.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c81150090.ofil5,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c81150090.oval51)
		e1:SetLabelObject(tc)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetLabelObject(e1)
		e2:SetOperation(c81150090.oop52)
		Duel.RegisterEffect(e2,tp)
		tc:RegisterFlagEffect(81150090,RESET_EVENT+RESETS_STANDARD,0,0)
		tc=g:GetNext()
	end
end
function c81150090.oval51(e,te)
	return te:GetOwner()~=e:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
		and te:GetOwner():GetAttack()<e:GetHandler():GetAttack() and te:IsActivated()
end
function c81150090.oop52(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetLabelObject()
	if not tc:IsHasEffect(81150090) then
		tc:ResetFlagEffect(81150090)
		te:Reset()
		e:Reset()
	end
end