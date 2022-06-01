--그림자무리의 침심
function c81160100.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c81160100.ecn1)
	e2:SetTarget(c81160100.etg1)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c81160100.tg3)
	e3:SetOperation(c81160100.op3)
	e3:SetValue(c81160100.va3)
	c:RegisterEffect(e3)
end

function c81160100.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcb3) and c:IsType(TYPE_SYNCHRO)
end
function c81160100.act(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81160100.filter1,tp,LOCATION_MZONE,0,1,nil)
end

--effect
function c81160100.ecn1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_SZONE,1,nil)
end
function c81160100.etg1(e,c)
	return c:IsSetCard(0xcb3)
end

function c81160100.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcb3) and c:IsControler(tp) and c:IsOnField()
	and c:IsReason(REASON_BATTLE+REASON_EFFECT)
	and (not c:IsReason(REASON_REPLACE) or not c:IsCode(81160100))
end
function c81160100.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c81160100.filter2,1,e:GetHandler(),tp)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81160100.va3(e,c)
	return c81160100.filter2(c,e:GetHandlerPlayer())
end
function c81160100.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end


