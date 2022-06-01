function c52641017.initial_effect(c)
	aux.AddFusionProcMixRep(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x5f1),2,2)
    c:EnableReviveLimit()
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCountLimit(1,52641017)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c52641017.con)
    e1:SetTarget(c52641017.rmtg)
    e1:SetOperation(c52641017.rmop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,526410171)
    e2:SetTarget(c52641017.sptg)
    e2:SetOperation(c52641017.spop)
    c:RegisterEffect(e2)
end
function c52641017.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c52641017.filter(c)
    return c:IsAbleToRemove()
end

function c52641017.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return c52641017.filter(chkc) end
    if chk==0 then return Duel.IsExistingTarget(c52641017.filter,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingTarget(c52641017.filter,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectTarget(tp,c52641017.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g2=Duel.SelectTarget(tp,c52641017.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c52641017.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tg=g:Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()>0 then
        Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
    end
end

function c52641017.spfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(0x5f1) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c52641017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c52641017.spfilter(chkc,e,tp) and chkc~=e:GetHandler() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingTarget(c52641017.spfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler(),e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,c52641017.spfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler(),e,tp)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c52641017.spop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end