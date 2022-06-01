--소울차져 아카이브
function c52646016.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,52646016+EFFECT_COUNT_CODE_OATH)
    e1:SetOperation(c52646016.activate)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52646016,2))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCost(c52646016.rmcost)
    e2:SetTarget(c52646016.rmtg)
    e2:SetOperation(c52646016.rmop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_UPDATE_LEVEL)
    e3:SetRange(LOCATION_FZONE)
    e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
    e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5f6))
    e3:SetValue(-1)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1)
    e4:SetCondition(c52646016.mtcon)
    e4:SetOperation(c52646016.mtop)
    c:RegisterEffect(e4)
end
function c52646016.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5f6) and c:IsAbleToHand()
end
function c52646016.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(c52646016.thfilter,tp,LOCATION_DECK,0,nil)
    if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(52646016,0)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local sg=g:Select(tp,1,1,nil)
        Duel.SendtoHand(sg,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,sg)
    end
end

function c52646016.rmcfilter(c,tp)
    return c:IsSetCard(0x5f6) and c:IsAbleToRemoveAsCost()
end
function c52646016.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c52646016.rmcfilter,tp,LOCATION_GRAVE,0,1,c,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c52646016.rmcfilter,tp,LOCATION_GRAVE,0,1,1,c,tp)
    g:AddCard(c)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c52646016.rmfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c52646016.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and c52646016.rmfilter(chkc) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(c52646016.rmfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectTarget(tp,c52646016.rmfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c52646016.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
    end
end
function c52646016.mtcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function c52646016.cfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c52646016.mtop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.HintSelection(Group.FromCards(c))
    local g=Duel.GetMatchingGroup(c52646016.cfilter,tp,LOCATION_GRAVE,0,nil)
    local sel=1
    if g:GetCount()~=0 then
        sel=Duel.SelectOption(tp,aux.Stringid(52646016,1),aux.Stringid(52646016,2))
    else
        sel=Duel.SelectOption(tp,aux.Stringid(52646016,2))+1
    end
    if sel==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
        local tg=g:Select(tp,1,1,nil)
        Duel.SendtoDeck(tg,nil,2,REASON_COST)
    else
        Duel.Destroy(c,REASON_COST)
    end
end