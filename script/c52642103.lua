--신식의 은둔자
local m=52642103
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_REMOVED)
    e1:SetCode(EVENT_REMOVE)
    e1:SetCountLimit(1,m)
    e1:SetCondition(cm.tgcon)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,2))
    e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,152642103)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(cm.target)
    e2:SetOperation(cm.activate)
    c:RegisterEffect(e2)
end
function cm.cfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_GRAVE) and c:IsControler(tp)
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    return eg and eg:IsExists(cm.cfilter,1,c,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function cm.filter(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and cm.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
    if sg:GetCount()>0 then
        Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
    end
end