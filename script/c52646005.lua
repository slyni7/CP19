--소울차져 「절망」
function c52646005.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPSUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetCountLimit(1,52646005)
    e1:SetCondition(c52646005.spcon)
    e1:SetTarget(c52646005.sptg)
    e1:SetOperation(c52646005.spop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52646005,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1,52646995)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c52646005.ovlinkcon0)
    e2:SetTarget(c52646005.hsptg)
    e2:SetOperation(c52646005.hspop)
    --c:RegisterEffect(e2)
	--adchange
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_SWAP_BASE_AD)
    e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCondition(c52646005.ovlinkcon1)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_BATTLED)
	e4:SetCondition(c52646005.ovlinkcon1)
    e4:SetTarget(c52646005.destg)
    e4:SetOperation(c52646005.desop)
    c:RegisterEffect(e4)
	--KABOOM!
	local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(52646005,1))
    e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,52646895)
	e5:SetRange(LOCATION_MZONE)
    e5:SetCondition(c52646005.ovlinkcon5)
    e5:SetTarget(c52646005.adestg)
    e5:SetOperation(c52646005.adesop)
    c:RegisterEffect(e5)
	--gain soul
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c52646005.soulcon)
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
function c52646005.linkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c52646005.ovlinkcon0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646005.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)==0
end
function c52646005.filter(c,e,tp)
    return c:IsSetCard(0x5f6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c52646005.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c52646005.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c52646005.hspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c52646005.filter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c52646005.adestg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c52646005.adesop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function c52646005.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRelateToBattle() end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c52646005.desop(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return end
    if e:GetHandler():IsRelateToBattle() then
        Duel.Destroy(e:GetHandler(),REASON_EFFECT)
    end
end
function c52646005.gvfilter(c,e,sp)
    return c:IsSetCard(0x5f6) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c52646005.gvsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c52646005.gvfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c52646005.gvspop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c52646005.gvfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c52646005.soulcon(e)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x5f7)
end
function c52646005.linkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c52646005.ovlinkcon0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646005.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)==0
end
function c52646005.ovlinkcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646005.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=1
end
function c52646005.ovlinkcon5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646005.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=5
end
function c52646005.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x5f7)
end
function c52646005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c52646005.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end