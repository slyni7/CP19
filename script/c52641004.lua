function c52641004.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c52641004.spcon)
    e1:SetOperation(c52641004.spop)
    c:RegisterEffect(e1)
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52641004,1))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,526410041)
    e2:SetTarget(c52641004.rhtg)
    e2:SetOperation(c52641004.rhop)
    c:RegisterEffect(e2)
end
function c52641004.spfilter(c)
    return c:IsSetCard(0x5f1) and c:IsAbleToGraveAsCost()
end
function c52641004.spcon(e,c)
    if c==nil then return true end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c52641004.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c52641004.spop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c52641004.spfilter,tp,LOCATION_HAND,0,1,1,c)
    Duel.SendtoGrave(g,REASON_COST)
end
function c52641004.filter(c)
    return c:IsSetCard(0x5f1) and c:IsAbleToHand()
end
function c52641004.rhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c52641004.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c52641004.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c52641004.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c52641004.rhop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end