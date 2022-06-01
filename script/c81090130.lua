--sakura, sakura
function c81090130.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--increase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcac))
	e2:SetTargetRange(LOCATION_MZONE,0)	
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,1)
	e4:SetCondition(c81090130.cn)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--detach
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81090130,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,81090130)
	e5:SetCondition(c81090130.ecn)
	e5:SetOperation(c81090130.eop)
	c:RegisterEffect(e5)
end

--immune
function c81090130.cn(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return tc and tc:IsControler(tp) and tc:IsSetCard(0xcac)
end

--detach
function c81090130.filter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcac)
end
function c81090130.ecn(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_COST)~=0 and re:IsHasType(0x7e0)
	and re:IsActiveType(TYPE_XYZ) and re:GetHandler():IsSetCard(0xcac)
	and ep==re:GetOwnerPlayer()
	and re:GetHandler():GetOverlayCount()>=ev-1
	and Duel.IsExistingMatchingCard(c81090130.filter,tp,LOCATION_DECK,0,1,nil)
end
function c81090130.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81090130.filter,tp,LOCATION_DECK,0,1,1,nil)
	return Duel.SendtoGrave(g,REASON_EFFECT)
end
