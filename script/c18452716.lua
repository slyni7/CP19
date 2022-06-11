--마법마왕융합(사토네 퓨전)
function c18452716.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetCountLimit(1,18452716+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c18452716.cost1)
	e1:SetTarget(c18452716.tar1)
	e1:SetOperation(c18452716.op1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(18452716,ACTIVITY_CHAIN,c18452716.afil1)
end
function c18452716.afil1(re,tp,cid)
	local rc=re:GetHandler()
	return not (rc:GetSummonLocation()==LOCATION_EXTRA and not re:IsActiveType(TYPE_FUSION))
end
function c18452716.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(18452716,tp,ACTIVITY_CHAIN)<1
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetValue(c18452716.val11)
	Duel.RegisterEffect(e1,tp)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c18452716.val11(e,re,tp)
	local rc=re:GetHandler()
	return rc:GetSummonLocation()==LOCATION_EXTRA and not re:IsActiveType(TYPE_FUSION)
end
function c18452716.tfil11(c,e,tp,m1,m2,f,chkf)
	local mg=m1
	if c.december_fmaterial then
		mg:Merge(m2)
	end
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil,chkf)
end
function c18452716.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local sfg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,0x46)
		mg1:Merge(sfg)
		local mg2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
		SatoneFusionFilter=function(c,e,tp)
			return c:IsSetCard(0x46) and c:IsControler(tp)
		end
		SatoneFusionEffect=e
		SatoneFusionPlayer=tp
		local res=Duel.IsExistingMatchingCard(c18452716.tfil11,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,mg2,nil,chkf)
		SatoneFusionFilter=nil
		SatoneFusionEffect=nil
		SatoneFusionPlayer=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c18452716.tfil1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,Group.CreateGroup(),mf,chkf)
			end
		end
		return res
	end
end
function c18452716.ofil1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c18452716.op1(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c18452716.ofil1,nil,e)
	local sfg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,0x46)
	mg1:Merge(sfg)
	local mg2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP):Filter(c18452716.ofil1,nil,e)
	SatoneFusionFilter=function(c,e,tp)
		return c:IsSetCard(0x46) and c:IsControler(tp)
	end
	SatoneFusionEffect=e
	SatoneFusionPlayer=tp
	local sg1=Duel.GetMatchingGroup(c18452716.tfil11,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,mg2,nil,chkf)
	local mg3=nil
	local sg2=nil
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c18452716.tfil11,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,Group.CreateGroup(),mf,chkf)
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
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
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