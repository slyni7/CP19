--필리플렉터 프로젝션
local m=52640107
local cm=_G["c"..m]
function c52640107.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.tktg)
    e2:SetOperation(cm.tkop)
    c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,52640111,0,0x5fa,0,2500,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,52640111,0,0x5fa,0,2500,6,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then return end
    local token=Duel.CreateToken(tp,52640111)
    Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
	local de=Effect.CreateEffect(e:GetHandler())
    de:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    de:SetRange(LOCATION_MZONE)
    de:SetCode(EVENT_PHASE+PHASE_END)
    de:SetCountLimit(1)
    de:SetOperation(cm.desop)
    de:SetReset(RESET_EVENT+RESETS_STANDARD)
    token:RegisterEffect(de)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function cm.cfilter(c,tp)
    return c:IsFaceup() and c:GetLevel()>0
        and Duel.IsPlayerCanSpecialSummonMonster(tp,52640112,0,0x5fa,c:GetAttack(),c:GetDefense(),6,RACE_FIEND,ATTRIBUTE_DARK)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.cfilter(chkc,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
        Duel.IsExistingTarget(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    local g=Duel.SelectTarget(tp,cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
        or not Duel.IsPlayerCanSpecialSummonMonster(tp,52640112,0,0x5fa,tc:GetAttack(),tc:GetDefense(),6,RACE_FIEND,ATTRIBUTE_DARK) then return end
    local token=Duel.CreateToken(tp,52640112)
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetValue(tc:GetAttack())
    e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
    token:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_SET_BASE_DEFENSE)
    e2:SetValue(tc:GetDefense())
    token:RegisterEffect(e2)
    Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end