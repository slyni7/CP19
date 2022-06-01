--레미니스 마거스 린
function c52641003.initial_effect(c)
    --특소시 파괴
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(52641003,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCountLimit(1,52641003)
    e1:SetTarget(c52641003.dstg)
    e1:SetOperation(c52641003.dsop)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52641003,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,526410031)
    e2:SetTarget(c52641003.sptg)
    e2:SetOperation(c52641003.spop)
    c:RegisterEffect(e2)
end
--
function c52641003.dsfilter(c,tp)
    return c:IsFaceup()
end
function c52641003.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chkc then return chkc:IsOnField() and c52641003.dsfilter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c52641003.dsfilter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,c52641003.dsfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end

function c52641003.dsop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.Destroy(tc,REASON_EFFECT)
    end
end
--
function c52641003.spfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x5f1) and not c:IsCode(52641003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c52641003.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c52641003.spfilter(chkc,e,tp) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c52641003.spfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c52641003.spfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c52641003.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end