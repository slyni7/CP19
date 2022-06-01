--기어스트리트
local m=52648009
local cm=_G["c"..m]
function c52648009.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetRange(LOCATION_FZONE)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetOperation(cm.ctop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e3:SetCode(EVENT_CHAINING)
    e3:SetRange(LOCATION_FZONE)
    e3:SetOperation(aux.chainreg)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCode(EVENT_CHAIN_SOLVED)
    e4:SetOperation(cm.acop)
    c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetCode(EFFECT_UPDATE_ATTACK)
    e5:SetRange(LOCATION_FZONE)
    e5:SetTargetRange(LOCATION_MZONE,0)
    e5:SetValue(cm.atkval)
    c:RegisterEffect(e5)
end
function cm.atkval(e,c)
    return c:GetCounter(0x1019)*100
end
function cm.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5f8) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
	Duel.Hint(HINT_CARD,0,m)
    while tc do
        if tc:IsFaceup() then
            tc:AddCounter(0x1019,1)
        end
        tc=eg:GetNext()
    end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
    e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
    local tc=re:GetHandler()
    if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not tc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or not tc:IsFaceup() then return end
    if e:GetHandler():GetFlagEffect(1)>0 then
        tc:AddCounter(0x1019,1)
    end
end