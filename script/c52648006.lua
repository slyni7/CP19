--기어스트리트래곤
local m=52648006
local cm=_G["c"..m]
function c52648006.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetRange(LOCATION_HAND)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
    e1:SetTargetRange(POS_FACEUP_ATTACK,1)
	e1:SetCountLimit(1,m)
    e1:SetCondition(cm.spcon)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(cm.disable)
    e2:SetCode(EFFECT_DISABLE)
    c:RegisterEffect(e2)
	--to hand
    local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,152648006)
    e3:SetCondition(aux.exccon)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(cm.thtg)
    e3:SetOperation(cm.thop)
    c:RegisterEffect(e3)
end
function cm.spfilter(c,tp)
	return c:IsReleasable() and c:GetCounter(0x1019)>0 and Duel.GetMZoneCount(1-tp,c,tp)>0 
end
function cm.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.IsExistingMatchingCard(cm.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
    local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
    Duel.Release(g,REASON_COST)
end
function cm.disable(e,c)
    return c~=e:GetHandler() and c:GetCounter(0x1019)>0 and (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT)
end
function cm.thfilter(c)
    return c:IsSetCard(0x5f8) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end