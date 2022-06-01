--잊을 수 없는 마음
function c52640003.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e1:SetTarget(c52640003.sptg)
    e1:SetOperation(c52640003.spop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e2:SetCondition(c52640003.handcon)
    c:RegisterEffect(e2)
end
function c52640003.filter(c,e,tp,tid)
    return c:GetTurnID()==tid and c:IsPreviousLocation(LOCATION_ONFIELD)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c52640003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tid=Duel.GetTurnCount()
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c52640003.filter(chkc,e,tp,tid) end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c52640003.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,tid) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c52640003.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,tid)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c52640003.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c52640003.handcon(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end