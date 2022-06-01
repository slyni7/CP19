--소울차져 「후회」
function c52646003.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPSUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetCountLimit(1,52646003)
    e1:SetCondition(c52646003.spcon)
    e1:SetTarget(c52646003.sptg)
    e1:SetOperation(c52646003.spop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52646003,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,52646987)
	e2:SetCondition(c52646003.ovlinkcon1)
    e2:SetCost(c52646003.descost)
    e2:SetTarget(c52646003.destg)
    e2:SetOperation(c52646003.desop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(52646003,2))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,52646997)
	e3:SetCondition(c52646003.ovlinkcon2)
    e3:SetCost(c52646003.descost1)
    e3:SetTarget(c52646003.destg1)
    e3:SetOperation(c52646003.desop1)
    c:RegisterEffect(e3)
	--gain soul
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c52646003.soulcon)
	e6:SetValue(300)
    c:RegisterEffect(e6)
	local e7=e6:Clone()
    e7:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
    e8:SetCode(EFFECT_CHANGE_RACE)
    e8:SetValue(RACE_CYBERSE)
	c:RegisterEffect(e8)
	local e9=e6:Clone()
    e9:SetCode(EFFECT_CHANGE_ATTRIBUTE)
    e9:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e9)
end
function c52646003.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c52646003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsOnField() end
    if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c52646003.desop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
function c52646003.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c52646003.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c52646003.desop1(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local sg=g:Select(tp,1,1,nil)
        Duel.HintSelection(sg)
        Duel.Destroy(sg,REASON_EFFECT)
    end
end
function c52646003.soulcon(e)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x5f7)
end
function c52646003.linkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c52646003.ovlinkcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646003.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=1
end
function c52646003.ovlinkcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646003.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=2
end
function c52646003.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x5f7)
end
function c52646003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c52646003.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
