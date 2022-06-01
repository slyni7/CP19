local m=52645007
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.sptg)
    e1:SetOperation(cm.spop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_REMOVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.mfilter0(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function cm.mfilter1(c,e)
    return c:IsOnField() and not c:IsImmuneToEffect(e)
end
function cm.mfilter2(c,e)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function cm.mfilter3(c,e)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function cm.mfilter4(c,e)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function cm.spfilter1(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.spfilter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0x5f5) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
        local res=Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if res then return true end
        local mg2=Duel.GetMatchingGroup(cm.mfilter0,tp,LOCATION_GRAVE,0,nil)
		local mg3=Duel.GetMatchingGroup(cm.mfilter4,tp,LOCATION_HAND,0,nil)
        mg2:Merge(mg1)
		mg2:Merge(mg3)
        res=Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(cm.mfilter1,nil,e)
    local sg1=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg2=Duel.GetMatchingGroup(cm.mfilter2,tp,LOCATION_GRAVE,0,nil,e)
	local mg3=Duel.GetMatchingGroup(cm.mfilter3,tp,LOCATION_HAND,0,nil,e)
    mg2:Merge(mg1)
	mg2:Merge(mg3)
    local sg2=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf)
    sg1:Merge(sg2)
    local mg3=nil
    local sg3=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg3=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
        local sg=sg1:Clone()
        if sg3 then sg:Merge(sg3) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            if tc:IsSetCard(0x5f5) then
                local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
                tc:SetMaterial(mat1)
                local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
                mat1:Sub(mat2)
                Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
                Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            else
                local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
                tc:SetMaterial(mat2)
                Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            end
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat)
        end
        tc:CompleteProcedure()
    end
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end