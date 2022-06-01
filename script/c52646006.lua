--그대의 마음을 알고싶어
function c52646006.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,52646006)
    e1:SetCost(c52646006.cost)
    e1:SetTarget(c52646006.target)
    e1:SetOperation(c52646006.activate)
    c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(52646006,ACTIVITY_SPSUMMON,c52646006.counterfilter)
end
function c52646006.counterfilter(c)
    return c:IsSetCard(0x5f6) or c:IsSetCard(0x5f7)
end
function c52646006.filter(c,e,tp)
    return c:IsSetCard(0x5f6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c52646006.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
        and Duel.IsExistingMatchingCard(c52646006.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c52646006.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectMatchingCard(tp,c52646006.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g1:GetCount()>0 then
        local fid=e:GetHandler():GetFieldID()
        local tc=g1:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            tc:RegisterFlagEffect(52646006,RESET_EVENT+RESETS_STANDARD,0,1,fid)
            tc=g1:GetNext()
        end
        Duel.SpecialSummonComplete()
        g1:KeepAlive()
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e1:SetCountLimit(1)
        e1:SetLabel(fid)
        e1:SetLabelObject(g1)
        e1:SetCondition(c52646006.rmcon)
        e1:SetOperation(c52646006.rmop)
        Duel.RegisterEffect(e1,tp)
    end
end

function c52646006.rmfilter(c,fid)
    return c:GetFlagEffectLabel(52646006)==fid
end
function c52646006.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if not g:IsExists(c52646006.rmfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function c52646006.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local tg=g:Filter(c52646006.rmfilter,nil,e:GetLabel())
    Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end

function c52646006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetCustomActivityCount(52646006,tp,ACTIVITY_SPSUMMON)==0 end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    e1:SetLabelObject(e)
    e1:SetTarget(c52646006.splimit)
    Duel.RegisterEffect(e1,tp)
end
function c52646006.splimit(e,c,sump,sumtype,sumpos,targetp,se)
    return not (c:IsSetCard(0x5f6) or c:IsSetCard(0x5f7))
end