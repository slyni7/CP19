--패스파인더 큐리오시티
function c52643008.initial_effect(c)
	--링크 소재
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5f3),2,2)
	--링크 소환 성공
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,52643008)
    e1:SetCondition(c52643008.spcon)
    e1:SetTarget(c52643008.sptg)
    e1:SetOperation(c52643008.spop)
    c:RegisterEffect(e1)
	--효과 파괴 내성
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_SZONE,0)
    e2:SetTarget(c52643008.indtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
	--카운터 제외 후 제외
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1,52643992)
    e3:SetCost(c52643008.cost)
    e3:SetTarget(c52643008.rmtg)
    e3:SetOperation(c52643008.rmop)
    c:RegisterEffect(e3)
end
function c52643008.indtg(e,c)
    return c:IsSetCard(0x15f3) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:GetSequence()<5
end
function c52643008.spfilter1(c,e,tp,zone)
    return c:IsSetCard(0x5f3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c52643008.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c52643008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local zone=e:GetHandler():GetLinkedZone(tp)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
        and Duel.IsExistingMatchingCard(c52643008.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c52643008.spop(e,tp,eg,ep,ev,re,r,rp)
    local zone=e:GetHandler():GetLinkedZone(tp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c52643008.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
    end
end
function c52643008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5ff,3,REASON_COST) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.RemoveCounter(tp,1,0,0x5ff,3,REASON_COST)
end
function c52643008.filter3(c)
    return c:IsAbleToRemove()
end
function c52643008.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52643008.filter3,tp,0,LOCATION_ONFIELD,1,nil) end
    local g=Duel.GetMatchingGroup(c52643008.filter3,tp,0,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c52643008.rmop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c52643008.filter3,tp,0,LOCATION_ONFIELD,1,1,nil)
    if g:GetCount()>0 then
        Duel.HintSelection(g)
        Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
    end
end