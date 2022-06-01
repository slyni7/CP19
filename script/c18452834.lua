--사이파이 러너웨이
local m=18452834
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil11(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCustomType(CUSTOMTYPE_SQUARE) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.tfil12(c)
	if c:IsCustomType(CUSTOMTYPE_SQUARE) then
		if c:IsSpecialSummonable(SUMMON_TYPE_SQUARE) then
			return true
		end
		if c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil) then
			return true
		end
		if c:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil) then
			return true
		end
		if c:IsType(TYPE_ACCESS) and c:IsSpecialSummonable(SUMMON_TYPE_ACCESS) then
			return true
		end
		if c:IsType(TYPE_ORDER) and c:IsSpecialSummonable(SUMMON_TYPE_ORDER) then
			return true
		end
		if c:IsType(TYPE_MODULE) and c:IsSpecialSummonable(SUMMON_TYPE_MODULE) then
			return true
		end
	end
	return false
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local e1=MakeEff(c,"F")
		if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetValue(cm.tval11)
			Duel.RegisterEffect(e1,tp)
		end
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local b1=Duel.IEMCard(cm.tfil11,tp,"E",0,1,nil,e,tp,mg1,nil,chkf)
		if not b1 then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				b1=Duel.IEMCard(cm.tfil11,tp,"E",0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		local b2=Duel.IEMCard(cm.tfil12,tp,"HE",0,1,nil)
		local res=b1 or b2
		e1:Reset()
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"HE")
end
function cm.tval11(e,c)
	return ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_DARK
end
function cm.ofil1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"F")
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.tval11)
		Duel.RegisterEffect(e1,tp)
	end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.ofil1,nli,e)
	local sg1=Duel.GMGroup(cm.tfil11,tp,"E",0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GMGroup(cm.tfil11,tp,"E",0,nil,e,tp,mg2,mf,chkf)
	end
	local b1=#sg1>0 or (sg2~=nil and #sg2>0)
	local b2=Duel.IEMCard(cm.tfil12,tp,"HE",0,1,nil)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if off==1 then
		e1:Reset()
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local sg=sg1:Clone()
		if sg2 then
			sg:Merge(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
	elseif opval[op]==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SMCard(tp,cm.tfil12,tp,"HE",0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			if tc:IsSpecialSummonable(SUMMON_TYPE_SQUARE) then
				Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_SQUARE)
			elseif tc:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil) then
				Duel.SynchroSummon(tp,tc,nil)
			elseif tc:IsType(TYPE_XYZ) and c:IsXyzSummonable(nil) then
				Duel.XyzSummon(tp,tc,nil)
			elseif tc:IsType(TYPE_ACCESS) and c:IsSpecialSummonable(SUMMON_TYPE_ACCESS) then
				Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_ACCESS)
			elseif tc:IsType(TYPE_ORDER) and c:IsSpecialSummonable(SUMMON_TYPE_ORDER) then
				Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_ORDER)
			elseif tc:IsType(TYPE_MODULE) and c:IsSpecialSummonable(SUMMON_TYPE_MODULE) then
				Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_MODULE)
			end
		end
	end
	e:Reset()
end