--BF－月影のカルート
function c52641006.initial_effect(c)
    --atkup
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetDescription(aux.Stringid(52641006,0))
    e1:SetCategory(CATEGORY_ATKCHANGE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(TIMING_DAMAGE_STEP)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCondition(c52641006.condition)
    e1:SetCost(c52641006.cost)
    e1:SetOperation(c52641006.operation)
    c:RegisterEffect(e1)
	--spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52641006,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(c52641006.dscost)
    e2:SetTarget(c52641006.dstg)
    e2:SetOperation(c52641006.dsop)
    c:RegisterEffect(e2)
end
function c52641006.condition(e,tp,eg,ep,ev,re,r,rp)
    local phase=Duel.GetCurrentPhase()
    if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    return (a:GetControler()==tp and a:IsSetCard(0x5f1) and a:IsRelateToBattle())
        or (d and d:GetControler()==tp and d:IsSetCard(0x5f1) and d:IsRelateToBattle())
end
function c52641006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c52641006.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetAttacker()
    if Duel.GetTurnPlayer()~=tp then a=Duel.GetAttackTarget() end
    if not a:IsRelateToBattle() then return end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
    e1:SetValue(1500)
    a:RegisterEffect(e1)
end
function c52641006.rfilter(c)
    return c:IsCode(52641006) and c:IsAbleToRemoveAsCost()
end
function c52641006.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52641006.rfilter,tp,LOCATION_GRAVE,0,3,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c52641006.rfilter,tp,LOCATION_GRAVE,0,3,3,nil)
    Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c52641006.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c52641006.dsop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
    Duel.Destroy(g,REASON_EFFECT)
end