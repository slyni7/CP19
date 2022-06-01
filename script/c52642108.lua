--신식의 지원
local m=52642108
local cm=_G["c"..m]
function c52642108.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_CHAINING)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(cm.handcon)
    c:RegisterEffect(e2)
end
function cm.cfilter(c)
    return c:IsFaceup() and (c:IsSetCard(0x5fc) or c:IsCode(72710085))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    if not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) then return false end
    if not Duel.IsChainNegatable(ev) then return false end
    return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
    end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
    end
end
function cm.recfilter(c)
    return c:IsFaceup() and (c:IsSetCard(0x5fc) or c:IsCode(72710085))
end
function cm.handcon(e)
	local g=Duel.GetMatchingGroup(cm.recfilter,tp,LOCATION_REMOVED,0,nil)
    local rec=g:GetClassCount(Card.GetAttribute)
    return rec>2
end