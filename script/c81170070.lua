--운명의 5분
function c81170070.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,81170070)
	e1:SetCondition(c81170070.cn1)
	e1:SetTarget(c81170070.tg1)
	e1:SetOperation(c81170070.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c81170070.cn2)
	c:RegisterEffect(e2)
	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCountLimit(1,81170071)
	e3:SetCost(c81170070.co3)
	e3:SetTarget(c81170070.tg3)
	e3:SetOperation(c81170070.op3)
	c:RegisterEffect(e3)
end

--activation
function c81170070.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcb4)
end
function c81170070.cn1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev)
	and Duel.IsExistingMatchingCard(c81170070.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c81170070.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81170070.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function c81170070.filter2(c)
	return c:IsFaceup() and c:IsCode(81170000)
end
function c81170070.cn2(e)
	return Duel.IsExistingMatchingCard(c81170070.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

--search
function c81170070.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcb4)
end
function c81170070.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81170070.cfilter,tp,0x02+0x10,0,2,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81170070.cfilter,tp,0x02+0x10,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81170070.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c81170070.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
