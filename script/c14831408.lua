--길고 긴 여행의 끝에 우리들은(유노미 퓨전)
function c14831408.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14831408+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c14831408.cost)
	e1:SetTarget(c14831408.target)
	e1:SetOperation(c14831408.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(14831408,ACTIVITY_SPSUMMON,c14831408.counterfilter)
end
function c14831408.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or c:IsType(TYPE_FUSION)
end
function c14831408.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(14831408,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c14831408.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c14831408.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function c14831408.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsControler,nil,1-tp)<=1
end
function c14831408.gcheck(tp)
	return  function(sg)
			return sg:FilterCount(Card.IsControler,nil,1-tp)<=1
	end
end
function c14831408.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsCanBeFusionMaterial()
end
function c14831408.spfilter(c,e,tp,m1,m2,f,chkf)
	local mg=m1
	if c.december_fmaterial then
		mg:Merge(m2)
	end
	return c:IsType(TYPE_FUSION) and c:IsRankAbove(1) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil,chkf)
end
function c14831408.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local sfg=Duel.GetMatchingGroup(c14831408.cfilter,tp,0,LOCATION_MZONE,nil)
		mg1:Merge(sfg)
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
		SatoneFusionFilter=function(c,e,tp)
			return c:GetSummonLocation()==LOCATION_EXTRA and c:IsControler(1-tp)
		end
		SatoneFusionEffect=e
		SatoneFusionPlayer=tp
		Auxiliary.FCheckAdditional=c14831408.fcheck
		Auxiliary.GCheckAdditional=c14831408.gcheck(tp)
		local res=Duel.IsExistingMatchingCard(c14831408.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,mg2,nil,chkf)
		SatoneFusionFilter=nil
		SatoneFusionEffect=nil
		SatoneFusionPlayer=nil
		Auxiliary.FCheckAdditional=nil
		Auxiliary.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c14831408.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,Group.CreateGroup(),mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c14831408.filter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c14831408.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c14831408.filter,nil,e)
	local sfg=Duel.GetMatchingGroup(c14831408.cfilter,tp,0,LOCATION_MZONE,nil)
	mg1:Merge(sfg)
	local mg2=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler()):Filter(c14831408.filter,nil,e)
		SatoneFusionFilter=function(c,e,tp)
			return c:GetSummonLocation()==LOCATION_EXTRA and c:IsControler(1-tp)
		end
		SatoneFusionEffect=e
		SatoneFusionPlayer=tp
		Auxiliary.FCheckAdditional=c14831408.fcheck
		Auxiliary.GCheckAdditional=c14831408.gcheck(tp)
	local sg1=Duel.GetMatchingGroup(c14831408.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,mg2,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	Auxiliary.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c14831408.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,Group.CreateGroup(),mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then
			sg:Merge(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc.december_fmaterial then
				mg1:Merge(mg2)
			end
				Auxiliary.FCheckAdditional=c14831408.fcheck
				Auxiliary.GCheckAdditional=c14831408.gcheck(tp)
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			Auxiliary.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
	SatoneFusionFilter=nil
	SatoneFusionEffect=nil
	SatoneFusionPlayer=nil
end