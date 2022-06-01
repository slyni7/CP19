--할로할로위즈 퓨전
local m=18452751
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_POSITION)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","G")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_POSITION)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(aux.exccon)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.tfil2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2d2) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GMFaceupGroup(Card.IsCanBeFusionMaterial,tp,0,"M",nil)
		mg1:Merge(mg2)
		local res=Duel.IEMCard(cm.tfil2,tp,"E",0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IEMCard(cm.tfil2,tp,"E",0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsNotImmuneToEffect,nil,e)
	local mg2=Duel.GMFaceupGroup(Card.IsCanBeFusionMaterial,tp,0,"M",nil)
	mg1:Merge(mg2)
	local sg1=Duel.GMGroup(cm.tfil2,tp,"E",0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:Getvalue()
		sg2=Duel.GMGroup(cm.tfil2,tp,"E",0,nil,e,tp,mg3,mf,chkf)
	end
	if #sg1>0 or (sg2 and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then
			sg:Merge(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (not sg2 or not sg2:IsContains(tc)
			or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat)
			local omat=mat:Filter(Card.IsControler,nil,1-tp)
			mat:Sub(omat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			local oc=omat:GetFirst()
			while oc do
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_CHANGE_CODE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e1:SetValue(77994337)
				oc:RegisterEffect(e1)
				oc=omat:GetNext()
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
			local oc=omat:GetFirst()
			while oc do
				local e2=MakeEff(c,"S")
				e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(1)
				oc:RegisterEffect(e2)
				oc=omat:GetNext()
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cm.tfil31(c)
	return c:IsLoc("O") and c:IsAbleToRemove()
end
function cm.tfil32(c)
	return c:IsCanBeFusionMaterial() and (c:IsAbleToRemove() or c:IsLoc("M"))
		 and c:IsType(TYPE_MONSTER)
end
function cm.tfil33(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x12d2) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.tfun3(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x12d2)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		mg1=mg1:Filter(cm.tfil31,nil)
		local mg2=Duel.GMFaceupGroup(cm.tfil32,tp,"G","MG",nil)
		mg1:Merge(mg2)
		local g=Duel.GMFaceupGroup(nil,tp,"M","M",nil)
		aux.FCheckAdditional=cm.tfun3
		local res=Duel.IEMCard(cm.tfil33,tp,"E",0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce then
				local fgroup=ce:GetTarget()
				local mg4=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IEMCard(cm.tfil33,tp,"E",0,1,nil,e,tp,mg4,mf,chkf)
			end
		end
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
	Duel.SOI(0,CATEGORY_REMOVE,nil,0,0,"G")
end
function cm.ofil3(c,p)
	return c:IsLoc("M") and c:IsControler(p)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsNotImmuneToEffect,nil,e)
	mg1=mg1:Filter(cm.tfil31,nil)
	local mg2=Duel.GMFaceupGroup(cm.tfil32,tp,"G","MG",nil)
	mg1:Merge(mg2)
	aux.FCheckAdditional=cm.tfun3
	local sg1=Duel.GMGroup(cm.tfil33,tp,"E",0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:Getvalue()
		sg2=Duel.GMGroup(cm.tfil33,tp,"E",0,nil,e,tp,mg3,mf,chkf)
	end
	if #sg1>0 or (sg2 and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then
			sg:Merge(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (not sg2 or not sg2:IsContains(tc)
			or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			tc:SetMaterial(mat)
			local omat=mat:Filter(cm.ofil3,nil,1-tp)
			mat:Sub(omat)
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			local oc=omat:GetFirst()
			while oc do
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_CHANGE_CODE)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				e1:SetValue(77994337)
				oc:RegisterEffect(e1)
				oc=omat:GetNext()
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
			local oc=omat:GetFirst()
			while oc do
				local e2=MakeEff(c,"S")
				e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(1)
				oc:RegisterEffect(e2)
				oc=omat:GetNext()
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end