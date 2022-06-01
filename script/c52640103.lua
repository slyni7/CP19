--필리플렉터 드라이
local m=52640103
local cm=_G["c"..m]
function c52640103.initial_effect(c)
	--damage
    local ea=Effect.CreateEffect(c)
    ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    ea:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    ea:SetCondition(cm.damcon)
    ea:SetOperation(cm.damop)
    c:RegisterEffect(ea)
    --damage
    local eb=Effect.CreateEffect(c)
    eb:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
    eb:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    eb:SetCondition(cm.damcon2)
	eb:SetOperation(cm.damop)
	c:RegisterEffect(eb)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_DAMAGE)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
    e1:SetCondition(cm.condition)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
	 local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_HAND)
    e2:SetCountLimit(1,152640103)
    e2:SetCondition(cm.spcon)
    e2:SetTarget(cm.sptg2)
    e2:SetOperation(cm.spop2)
    c:RegisterEffect(e2)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp and Duel.GetTurnPlayer()==tp
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
   return ep~=tp
end
function cm.damcon2(e,tp,eg,ep,ev,re,r,rp)
   return ep==tp
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
   Duel.ChangeBattleDamage(1-ep,ev,false)
   Duel.ChangeBattleDamage(ep,0,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
        c:CompleteProcedure()
    end
end
function cm.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5fa) and not c:IsCode(m)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,500)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Damage(tp,500,REASON_EFFECT)
end