--CB(커먼 버그) - T(타이핑)error
local m=52649003
local cm=_G["c"..m]
function c52649003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.eqtg)
    e1:SetOperation(cm.eqop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,152649003)
    e2:SetCondition(cm.thcon)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
	local e8=Effect.CreateEffect(c)
    e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e8:SetCode(EVENT_SUMMON_SUCCESS)
    e8:SetOperation(cm.errop)
    c:RegisterEffect(e8)
	local e9=e8:Clone()
    e9:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e9)
end
function cm.errop(e,tp,eg,ep,ev,re,r,rp)
    Debug.Message("attempt to call an error function")
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
    local tc=Duel.GetFirstTarget()
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
        Duel.SendtoGrave(c,REASON_EFFECT)
        return
    end
    Duel.Equip(tp,c,tc,true)
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_EQUIP_LIMIT)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    e1:SetValue(cm.eqlimit)
    e1:SetLabelObject(tc)
    c:RegisterEffect(e1)
    --race
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_CHANGE_RACE)
    e2:SetValue(RACE_INSECT)
    e2:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e2)
	--cannot attack
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_EQUIP)
    e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
    e3:SetValue(cm.atlimit)
    e3:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e3)
    --disable
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetCode(EVENT_CHAIN_SOLVING)
    e4:SetRange(LOCATION_SZONE)
    e4:SetLabelObject(tc)
    e4:SetCondition(cm.discon)
    e4:SetOperation(cm.disop)
    e4:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e4)
end
function cm.eqlimit(e,c)
    return c==e:GetLabelObject()
end
function cm.atlimit(e,c)
    return c:IsRace(RACE_INSECT) and c:IsFaceup()
end
function cm.disfilter(c)
    return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsRace(RACE_INSECT)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
    local tc=e:GetLabelObject()
    local rc=re:GetHandler()
    if not tc or rc~=tc then return false end
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
    local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return g and g:IsExists(cm.disfilter,1,nil) and Duel.IsChainNegatable(ev)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.thfilter(c)
    return c:IsSetCard(0x5f9) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
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