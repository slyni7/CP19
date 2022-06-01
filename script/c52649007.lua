--CB(커먼 버그) - 하이젠버그
local m=52649007
local cm=_G["c"..m]
function c52649007.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,LOCATION_MZONE)
    e2:SetCode(EFFECT_CHANGE_LEVEL)
    e2:SetValue(2)
    c:RegisterEffect(e2)
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetTargetRange(0,LOCATION_MZONE)
    e3:SetCode(EFFECT_CHANGE_RACE)
    e3:SetValue(RACE_INSECT)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(0,LOCATION_MZONE)
    e4:SetTarget(cm.atglimit)
    e4:SetValue(cm.atlimit)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,LOCATION_MZONE)
    e5:SetTarget(cm.tglimit)
    e5:SetValue(cm.tgval)
    c:RegisterEffect(e5)
end
function cm.atglimit(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.atlimit(e,c)
    return c==e:GetHandler()
end
function cm.tglimit(e,c)
    return c==e:GetHandler()
end
function cm.tgval(e,re,rp)
    if not aux.tgoval(e,re,rp) then return false end
    local c=re:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.filter(c,e,tp)
    return c:IsFaceup() and c:IsRace(RACE_INSECT) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(cm.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
    end
end