--다원융합
function c52640005.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,52640005)
    e2:SetTarget(c52640005.target)
    e2:SetOperation(c52640005.activate)
    c:RegisterEffect(e2)
end
function c52640005.filter1(c,e)
    return not c:IsImmuneToEffect(e)
end
function c52640005.filter0(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGraveAsCost()
end
function c52640005.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsLevelBelow(10)
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c52640005.target(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c52640005.filter0,tp,LOCATION_DECK,0,nil)
            mg1:Merge(mg2)
        local res=Duel.IsExistingMatchingCard(c52640005.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c52640005.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        return res and Duel.GetLocationCountFromEx(1-tp)>0
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end
function c52640005.activate(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c52640005.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c52640005.filter0,tp,LOCATION_DECK,0,nil)
        mg1:Merge(mg2)
    local sg1=Duel.GetMatchingGroup(c52640005.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c52640005.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local off=1
			local ops={}
			local opval={}
			local sel=0
			if tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_FACEUP,1-tp,0x20) then
				ops[off]=aux.Stringid(52640005,0)
				opval[off-1]=1
				off=off+1
			end
			if tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_FACEUP,1-tp,0x40) then
				ops[off]=aux.Stringid(52640005,1)
				opval[off-1]=2
				off=off+1
			end
			if tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_FACEUP,1-tp,0x1F) then
				ops[off]=aux.Stringid(52640005,2)
				opval[off-1]=3
				off=off+1
			end
			if off<2 then
				return
			end
			local op=Duel.SelectOption(tp,table.unpack(ops))
			local sel=opval[op]
			if sel==1 then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,1-tp,false,false,POS_FACEUP,0x20)
			elseif sel==2 then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,1-tp,false,false,POS_FACEUP,0x40)
			else
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()			
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,1-tp,false,false,POS_FACEUP,0x1F)
			end
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end