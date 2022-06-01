--CB(커먼 버그) - 엑스칼리버그
local m=52649009
local cm=_G["c"..m]
function c52649009.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_ATTACK_ALL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_PIERCE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(cm.target)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(cm.damcon)
    e3:SetOperation(cm.damop)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.thcon)
    e4:SetTarget(cm.sptg)
    e4:SetOperation(cm.spop)
    c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(m,1))
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e5:SetCode(EVENT_ATTACK_ANNOUNCE)
    e5:SetRange(LOCATION_HAND)
    e5:SetCondition(cm.becon1)
    e5:SetCost(cm.becost)
    e5:SetOperation(cm.beop)
    c:RegisterEffect(e5)
    local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(m,1))
    e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e6:SetCode(EVENT_BE_BATTLE_TARGET)
    e6:SetRange(LOCATION_HAND)
    e6:SetCondition(cm.becon2)
    e6:SetCost(cm.becost)
    e6:SetOperation(cm.beop)
    c:RegisterEffect(e6)
end
function cm.becon1(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttacker()
    return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function cm.becon2(e,tp,eg,ep,ev,re,r,rp)
    local at=Duel.GetAttackTarget()
    return at:IsControler(tp) and at:IsFaceup() and at:IsRace(RACE_INSECT)
end
function cm.becost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsDiscardable() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.beop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.NegateAttack() then
        Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
    end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.target(e,c)
    return c:IsRace(RACE_INSECT)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return ep~=tp and tc:IsRace(RACE_INSECT) and tc:GetBattleTarget()~=nil and tc:GetBattleTarget():IsDefensePos()
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ChangeBattleDamage(ep,ev*2)
end
function cm.cfilter(c,e,tp,m)
    local mg=m:Filter(Card.IsCanBeRitualMaterial,e:GetHandler(),e:GetHandler())
    return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and mg:CheckWithSumGreater(Card.GetRitualLevel,e:GetHandler():GetLevel(),e:GetHandler())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg1=Duel.GetRitualMaterial(tp)
        mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
        return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,mg1)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local mg1=Duel.GetRitualMaterial(tp)
    mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
    local tc=e:GetHandler()
    if tc then
        local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        tc:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
