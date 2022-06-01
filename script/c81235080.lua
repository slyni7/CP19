--제6야상곡
--카드군 번호: 0xc90
function c81235080.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81235080+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81235080.tg1)
	e1:SetOperation(c81235080.op1)
	c:RegisterEffect(e1)
	
	--강제돚거
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81235080.tg2)
	e2:SetOperation(c81235080.op2)
	c:RegisterEffect(e2)
end

--융합소환
function c81235080.filter0(c,e)
	return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c81235080.exfilter0(c)
	return c:IsAbleToRemove() and c:IsCanBeFusionMaterial()
end
function c81235080.exfilter1(c,e)
	return c:IsAbleToRemove() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c81235080.spfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xc90) and ( not f or f(c) )
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
	and c:CheckFusionMaterial(m,nil,chkf)
end
function c81235080.mz(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
function c81235080.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
		if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
			local sg=Duel.GetMatchingGroup(c81235080.exfilter0,tp,LOCATION_GRAVE,0,nil)
			if sg:GetCount()>0 then
				mg1:Merge(sg)
				Auxiliary.FCheckAdditional=c81235080.mz
			end
		end
		local res=Duel.IsExistingMatchingCard(c81235080.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		Auxiliary.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c81235080.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c81235080.op1(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c81235080.filter0,nil,e)
	local exmat=false
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		local sg=Duel.GetMatchingGroup(c81235080.exfilter1,tp,LOCATION_GRAVE,0,nil,e)
		if sg:GetCount()>0 then
			mg1:Merge(sg)
			exmat=true
		end
	end
	if exmat then Auxiliary.FCheckAdditional=c81235080.mz end
	local sg1=Duel.GetMatchingGroup(c81235080.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	Auxiliary.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c81235080.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or ( sg2~=nil and sg2:GetCount()>0 ) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		mg1:RemoveCard(tc)
		if sg1:IsContains(tc) and ( sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription()) ) then
			if exmat then Auxiliary.FCheckAdditional=c81235080.mz end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			Auxiliary.FCheckAdditional=nil
			tc:SetMaterial(mat1)
			local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
			mat1:Sub(rg)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end

--강제돚거
function c81235080.tfilter(c)
	return c:IsSSetable(ignore) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81235080.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81235080.tfilter,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	end
end
function c81235080.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then
		return
	end
	local g=Duel.GetMatchingGroup(c81235080.tfilter,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.SSet(1-tp,sg:GetFirst())
		e:SetLabelObject(sg:GetFirst())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sg:GetFirst():RegisterEffect(e1)
	end
end