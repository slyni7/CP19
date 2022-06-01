--Raindrop Raspberrying
function c14931419.initial_effect(c)
	--counter card
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,14931419+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c14931419.condition)
	e1:SetTarget(c14931419.distg)
	e1:SetOperation(c14931419.disop)
	c:RegisterEffect(e1)
end
function c14931419.scfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb93) and c:IsType(TYPE_XYZ)
end
function c14931419.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb93)
end
function c14931419.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsExistingMatchingCard(c14931419.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c14931419.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if Duel.IsExistingMatchingCard(c14931419.scfilter,tp,LOCATION_MZONE,0,1,nil)
	then return Duel.SetChainLimit(aux.FALSE) end
end
function c14931419.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end