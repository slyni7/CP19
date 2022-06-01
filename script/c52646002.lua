--소울차져 「고독」
function c52646002.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPSUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_BE_MATERIAL)
    e1:SetCountLimit(1,52646002)
    e1:SetCondition(c52646002.spcon)
    e1:SetTarget(c52646002.sptg)
    e1:SetOperation(c52646002.spop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52646002,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetCountLimit(1,52646998)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCondition(c52646002.ovlinkcon0)
    e2:SetTarget(c52646002.hsptg)
    e2:SetOperation(c52646002.hspop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_SET_POSITION)
	e3:SetCondition(c52646002.ovlinkcon1)
    e3:SetValue(POS_FACEUP_DEFENSE)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_DEFENSE_ATTACK)
	e4:SetCondition(c52646002.ovlinkcon1)
    e4:SetValue(1)
    c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(52646002,1))
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e5:SetCode(EFFECT_CANNOT_ACTIVATE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetTargetRange(0,1)
    e5:SetValue(c52646002.aclimit)
    e5:SetCondition(c52646002.actcon)
    c:RegisterEffect(e5)
	--gain soul
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCondition(c52646002.soulcon)
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
function c52646002.soulcon(e)
    return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x5f7)
end
function c52646002.linkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c52646002.ovlinkcon0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646002.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)==0
end
function c52646002.ovlinkcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646002.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=1
end
function c52646002.aclimit(e,re,tp)
    return not re:GetHandler():IsImmuneToEffect(e)
end
function c52646002.actcon(e)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(c52646002.linkfilter,nil)
    return (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()) and g:GetSum(Card.GetLink,nil)>=3
end
function c52646002.hspfilter(c,e,sp)
    return c:IsSetCard(0x5f6) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c52646002.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c52646002.hspfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c52646002.hspop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c52646002.hspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c52646002.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsLocation(LOCATION_GRAVE) and r==REASON_LINK and c:GetReasonCard():IsSetCard(0x5f7)
end
function c52646002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c52646002.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end