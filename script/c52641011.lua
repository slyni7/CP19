--레미니스 게이트웨이
function c52641011.initial_effect(c)
    --special summon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(52641011,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TOGRAVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,52641011)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetTarget(c52641011.target)
    e1:SetOperation(c52641011.activate)
    c:RegisterEffect(e1)
end
function c52641011.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
    return e:GetLabelObject()~=se
end
function c52641011.filter0(c)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c52641011.filter1(c,e)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c52641011.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0x5f1) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c52641011.filter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c52641011.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg=Duel.GetMatchingGroup(c52641011.filter0,tp,LOCATION_REMOVED,0,nil)
        local res=Duel.IsExistingMatchingCard(c52641011.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c52641011.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c52641011.activate(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg=Duel.GetMatchingGroup(c52641011.filter1,tp,LOCATION_REMOVED,0,nil,e)
    local sg1=Duel.GetMatchingGroup(c52641011.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
    local mg3=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c52641011.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
            tc:SetMaterial(mat)
            Duel.SendtoGrave(mat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end
