function c52640000.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x8d),2,2)
    c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_CHAINING)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c52640000.chcon)
    e1:SetOperation(c52640000.chop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_MSET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,52640000)
    e2:SetTarget(c52640000.thtg)
    e2:SetOperation(c52640000.thop)
    c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EVENT_SSET)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c52640000.econ)
    c:RegisterEffect(e4)
	--특소
	local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e5:SetCode(EFFECT_SPSUMMON_PROC)
    e5:SetRange(LOCATION_EXTRA)
    e5:SetCondition(c52640000.hspcon)
    e5:SetOperation(c52640000.hspop)
    c:RegisterEffect(e5)
end
function c52640000.hspfilter(c,tp,sc)
    return c:IsFacedown() and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c52640000.hspcon(e,c)
    if c==nil then return true end
    return Duel.CheckReleaseGroup(c:GetControler(),c52640000.hspfilter,2,nil,c:GetControler(),c)
end
function c52640000.hspop(e,tp,eg,ep,ev,re,r,rp,c)
    local g=Duel.SelectReleaseGroup(tp,c52640000.hspfilter,2,2,nil,tp,c)
    Duel.Release(g,g,REASON_COST+REASON_MATERIAL)
end
function c52640000.matfilter(c,lc,sumtype,tp)
    return c:IsSetCard(0x8d,lc,sumtype,tp) or c:IsFacedown()
end
function c52640000.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and re:IsHasCategory(CATEGORY_POSITION)
end
function c52640000.chop(e,tp,eg,ep,ev,re,r,rp)
    local g=Group.CreateGroup()
    Duel.ChangeTargetCard(ev,g)
    Duel.ChangeChainOperation(ev,c52640000.repop)
end
function c52640000.tdfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsAbleToDeck()
end
function c52640000.repop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.SelectMatchingCard(tp,c52640000.tdfilter,tp,0,LOCATION_MZONE,1,1,nil)
    if sg:GetCount()>0 then
		Duel.HintSelection(sg)
        Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
    end
end
function c52640000.thfilter(c)
    return c:IsSetCard(0x8d) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c52640000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52640000.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c52640000.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c52640000.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
function c52640000.econ(e)
    return Duel.IsExistingMatchingCard(Card.IsPosition,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,POS_FACEDOWN_DEFENSE)
end