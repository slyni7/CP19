--스타폴링 나이트
function c52644011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOGRAVE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,52644011)
    e2:SetCondition(c52644011.tgcon)
    e2:SetTarget(c52644011.tgtg)
    e2:SetOperation(c52644011.tgop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e3:SetCode(EVENT_DESTROYED)
    e3:SetCountLimit(1,52644989)
    e3:SetTarget(c52644011.dstg)
    e3:SetOperation(c52644011.dsop)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
    e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCost(aux.bfgcost)
    e4:SetTarget(c52644011.tdtg)
    e4:SetOperation(c52644011.tdop)
    c:RegisterEffect(e4)
end
function c52644011.filter(c,tp)
    return c:IsFaceup() and c:IsControler(tp) and c:IsSetCard(0x5f4) and c:IsType(TYPE_MONSTER)
end
function c52644011.tgcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c52644011.filter,1,nil,tp)
end
function c52644011.tgfilter(c)
    return c:IsSetCard(0x5f4) and c:IsAbleToGrave()
end
function c52644011.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52644011.tgfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c52644011.tgop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c52644011.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoGrave(g,REASON_EFFECT)
    end
end
function c52644011.dstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c52644011.dsop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c52644011.tdfilter(c)
    return c:IsSetCard(0x5f4) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c52644011.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c52644011.tdfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c52644011.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,c52644011.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c52644011.tdop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    if g:GetCount()>0 then
    Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	local g1=Duel.GetOperatedGroup()
    if g1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
    local ct=g1:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
    if ct==g:GetCount() then
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
    end
end
