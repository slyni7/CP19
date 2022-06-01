--모략의 귀걸조
--카드군 번호: 0xc87
local m=81245050
local cm=_G["c"..m]
function cm.initial_effect(c)

	--패에서 발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.cn1)
	c:RegisterEffect(e1)
	
	--발동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--발동
function cm.cfil0(c)
	return c:IsDiscardable() and c:IsSetCard(0xc87) and c:IsType(0x1)
end
function cm.cn1(e)
	return Duel.GetCurrentChain()>1 and Duel.IsExistingMatchingCard(cm.cfil0,e:GetHandlerPlayer(),0x02,0,1,nil)
end
function cm.nfil0(c)
	return c:IsFaceup() and c:IsCode(81245010)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev) and Duel.IsExistingMatchingCard(cm.nfil0,tp,0x0c,0,1,nil)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.DiscardHand(tp,cm.cfil0,1,1,REASON_COST+REASON_DISCARD)
	end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
