--소울배터리 「둘이 함께한 추억」
function c52646013.initial_effect(c)
	--link summon
    aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5f6),2,2)
    c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e0:SetValue(1)
    c:RegisterEffect(e0)
	--material
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(52646013,0))
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c52646013.mattg)
    e1:SetOperation(c52646013.matop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(400)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_XMATERIAL)
    e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e3:SetValue(aux.tgoval)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
    e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,52646013)
	e4:SetCost(c52646013.thcost)
    e4:SetTarget(c52646013.thtg)
    e4:SetOperation(c52646013.thop)
    c:RegisterEffect(e4)
end
function c52646013.matfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f6)
end
function c52646013.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c52646013.matfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c52646013.matfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.SelectTarget(tp,c52646013.matfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c52646013.matop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,Group.FromCards(c))
    end
end
function c52646013.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c52646013.filter(c)
    return c:IsSetCard(0x5f6) and c:IsAbleToHand()
end
function c52646013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52646013.filter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c52646013.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c52646013.filter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end