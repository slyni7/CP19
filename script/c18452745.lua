--네레할로위즈 퓨전
local m=18452745
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=aux.AddEquipProcedure(c)
	local e2=MakeEff(c,"E")
	e2:SetCode(18452720)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"E")
	e3:SetCode(EFFECT_ADD_FUSION_SETCODE)
	e3:SetCondition(cm.con3)
	e3:SetValue(0x2d2)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","S")
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_POSITION)
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"I","G")
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_POSITION)
	e5:SetCountLimit(1,m+1)
	WriteEff(e5,5,"CTO")
	c:RegisterEffect(e5)
end
function cm.con2(e)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return ec:IsSetCard(0x2d2)
end
function cm.con3(e)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return not ec:IsSetCard(0x2d2)
end
function cm.tfil4(c,e,tp,m,ec,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2d2) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,ec,chkf)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GMFaceupGroup(Card.IsCanBeFusionMaterial,tp,0,"M",nil)
		mg1:Merge(mg2)
		local res=Duel.IEMCard(cm.tfil4,tp,"E",0,1,nil,e,tp,mg1,ec,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IEMCard(cm.tfil4,tp,"E",0,1,nil,e,tp,mg3,ec,mf,chkf)
			end
		end
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local ec=c:GetEquipTarget()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsNotImmuneToEffect,nil,e)
	local mg2=Duel.GMFaceupGroup(Card.IsCanBeFusionMaterial,tp,0,"M",nil)
	mg1:Merge(mg2)
	local sg1=Duel.GMGroup(cm.tfil4,tp,"E",0,nil,e,tp,mg1,ec,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:Getvalue()
		sg2=Duel.GMGroup(cm.tfil4,tp,"E",0,nil,e,tp,mg3,ec,mf,chkf)
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
			local mat=Duel.SelectFusionMaterial(tp,tc,mg1,ec,chkf)
			tc:SetMaterial(mat)
			local omat=mat:Filter(Card.IsControler,nil,1-tp)
			mat:Sub(omat)
			local e1=MakeEff(c,"SC","S")
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetTarget(cm.otar41)
			c:RegisterEffect(e1)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			e1:Reset()
			Duel.BreakEffect()
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			Duel.Equip(tp,c,tc)
			Duel.SpecialSummonComplete()
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
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,ec,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.otar41(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	return true
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cm.tfil51(c)
	return c:IsLoc("O") and c:IsAbleToRemove()
end
function cm.tfil52(c)
	return c:IsCanBeFusionMaterial() and (c:IsAbleToRemove() or c:IsLoc("M"))
		 and c:IsType(TYPE_MONSTER)
end
function cm.tfil53(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x12d2) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.tfun5(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x12d2)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		mg1=mg1:Filter(cm.tfil51,nil)
		local mg2=Duel.GMFaceupGroup(cm.tfil52,tp,"G","MG",nil)
		mg1:Merge(mg2)
		local g=Duel.GMFaceupGroup(nil,tp,"M","M",nil)
		aux.FCheckAdditional=cm.tfun5
		local res=Duel.IEMCard(cm.tfil53,tp,"E",0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce then
				local fgroup=ce:GetTarget()
				local mg4=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IEMCard(cm.tfil53,tp,"E",0,1,nil,e,tp,mg4,mf,chkf)
			end
		end
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
	Duel.SOI(0,CATEGORY_REMOVE,nil,0,0,"G")
end
function cm.ofil5(c,p)
	return c:IsLoc("M") and c:IsControler(p)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsNotImmuneToEffect,nil,e)
	mg1=mg1:Filter(cm.tfil51,nil)
	local mg2=Duel.GMFaceupGroup(cm.tfil52,tp,"G","MG",nil)
	mg1:Merge(mg2)
	aux.FCheckAdditional=cm.tfun5
	local sg1=Duel.GMGroup(cm.tfil53,tp,"E",0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:Getvalue()
		sg2=Duel.GMGroup(cm.tfil53,tp,"E",0,nil,e,tp,mg3,mf,chkf)
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
			local omat=mat:Filter(cm.ofil5,nil,1-tp)
			mat:Sub(omat)
			Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			local oc=omat:GetFirst()
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
			local oc=omat:GetFirst()
			while oc do
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(1)
				oc:RegisterEffect(e1)
				oc=omat:GetNext()
			end
			local rg=mat:Filter(Card.IsLoc,nil,"R")
			if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local fg=rg:Select(tp,1,1,nil)
				local fc=fg:GetFirst()
				local og=omat:Clone()
				og:AddCard(tc)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local pg=og:Select(tp,1,1,nil)
				local pc=pg:GetFirst()
				if Duel.Equip(tp,fc,pc) then
					local e2=MakeEff(c,"E")
					e2:SetCode(EFFECT_EQUIP_LIMIT)
					e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetReset(RESET_EVENT+0x1fe0000)
					e2:SetLabelObject(tc)
					e2:SetValue(cm.oval52)
					pc:RegisterEffect(e2)
					local e3=MakeEff(c,"S","S")
					e3:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
					e3:SetReset(RESET_EVENT+0x1fe0000)
					e3:SetValue(cm.oval53)
					pc:RegisterEffect(e3)
				end
			end
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.oval52(e,c)
	return e:GetLabelObject()==c
end
function cm.oval53(e,c)
	if not c then
		return false
	end
	return c:IsSetCard(0x2d2)
end