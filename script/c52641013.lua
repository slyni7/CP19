--레미니스 인셉션
function c52641013.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,52641013+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c52641013.target)
    e1:SetOperation(c52641013.activate)
    c:RegisterEffect(e1)
    --destroy replace
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EFFECT_DESTROY_REPLACE)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetTarget(c52641013.reptg)
    e2:SetValue(c52641013.repval)
    e2:SetOperation(c52641013.repop)
    c:RegisterEffect(e2)
end
function c52641013.filter(c)
    return c:IsSetCard(0x5f1) and not c:IsCode(52641013) and c:IsAbleToHand()
end
function c52641013.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52641013.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c52641013.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c52641013.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c52641013.repfilter(c,tp)
    return c:IsFaceup() and c:IsSetCard(0x5f1) and c:IsLocation(LOCATION_ONFIELD)
        and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function c52641013.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemove() and aux.exccon(e) and eg:IsExists(c52641013.repfilter,1,nil,tp) end
    return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c52641013.repval(e,c)
    return c52641013.repfilter(c,e:GetHandlerPlayer())
end
function c52641013.repop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
