--스타폴드 리킨들링
function c52644010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,152644010)
    c:RegisterEffect(e1)
    --스타폴 화염족	
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCountLimit(1,52644010)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c52644010.chtg)
    e2:SetOperation(c52644010.chop)
    c:RegisterEffect(e2)
	--파괴 회수
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,152644010)
    e3:SetTarget(c52644010.dstg)
    e3:SetOperation(c52644010.dsop)
    c:RegisterEffect(e3)
	
end
function c52644010.chfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f4)
end
function c52644010.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52644010.chfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function c52644010.chop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
    for tc in aux.Next(g) do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        e1:SetValue(RACE_PYRO)
        tc:RegisterEffect(e1)
    end
end
function c52644010.filter(c)
    return c:IsSetCard(0x5f4) and c:IsAbleToHand()
end
function c52644010.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_GRAVE and c52644010.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c52644010.filter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectTarget(tp,c52644010.filter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c52644010.dsop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SendtoHand(tc,nil,REASON_EFFECT)
    end
end