--쁘띠 케이키
--카드군 번호: 0xc9c
local m=81256010
local tkn=81255990
local cm=_G["c"..m]
function cm.initial_effect(c)

	--토큰
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(0x02+LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--특수소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	c:RegisterEffect(e2)
end

--토큰
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		return ( ft>-1 or ( c:IsLocation(0x02) and ft>0 ) )
		and Duel.IsPlayerCanSpecialSummonMonster(tp,tkn,0,0x4011,500,500,2,RACE_ROCK,ATTRIBUTE_EARTH)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.ofil0(c)
	return c:IsSSetable(ignore) and c:IsSetCard(0xc9c) and c:IsType(0x2+0x4)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,tkn,0,0x4011,500,500,2,RACE_ROCK,ATTRIBUTE_EARTH) then
		return
	end
	local token=Duel.CreateToken(tp,tkn)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.ofil0),tp,0x01+0x10,0,nil)
		if #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:Select(tp,1,1,nil)
			Duel.SSet(tp,sg:GetFirst())
		end
	end
end

--특수소환
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.cfil0(c,tp)
	return c:IsType(0x1) and Duel.GetMZoneCount(tp,c,tp)>0
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,cm.cfil0,1,nil,tp)
	end
	local g=Duel.SelectReleaseGroup(tp,cm.cfil0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc:IsSetCard(0xc9c) and tc:IsType(TYPE_FUSION) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.Release(tc,REASON_COST)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.filter2(c,e,tp,m,f,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xc9c) and (not f or f(c))
	and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_FACEUP) and c:CheckFusionMaterial(m,gc,chkf)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 or not c:IsLocation(0x04) then
		return
	end
	if c:IsFacedown() then
		return
	end
	if e:GetLabel()>0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)
		local sg1=Duel.GetMatchingGroup(cm.filter2,tp,0x40,0,nil,e,tp,mg1,nil,c,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(cm.filter2,tp,0x40,0,nil,e,tp,mg2,mf,c,chkf)
		end
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			if #sg1>0 or (sg2~=nil and #sg2>0) then
				Duel.BreakEffect()
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
					tc:SetMaterial(mat1)
					Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
					local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)
					local fop=ce:GetOperation()
					fop(ce,e,tp,tc,mat2)
				end
				tc:CompleteProcedure()
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(0x20)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	c:RegisterEffect(e1,true)
end
		