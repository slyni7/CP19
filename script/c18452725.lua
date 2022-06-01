--스타할로위즈 할로할로
local m=18452725
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_REMOVE)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_REMOVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,m+1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.tfil1(c,e,tp,m,ec,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2d2) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GMFaceupGroup(Card.IsCanBeFusionMaterial,tp,0,"M",nil)
		mg1:Merge(mg2)
		local res=Duel.IEMCard(cm.tfil1,tp,"E",0,1,nil,e,tp,mg1,c,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IEMCard(cm.tfil1,tp,"E",0,1,nil,e,tp,mg3,c,mf,chkf)
			end
		end
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.ofil1(c,e)
	return c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and c:IsNotImmuneToEffect(e)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsNotImmuneToEffect,nil,e)
	local mg2=Duel.GMFaceupGroup(cm.ofil1,tp,0,"M",nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GMGroup(cm.tfil1,tp,"E",0,nil,e,tp,mg1,c,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:Getvalue()
		sg2=Duel.GMGroup(cm.tfil1,tp,"E",0,nil,e,tp,mg3,c,mf,chkf)
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
			local mat=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat)
			local omat=mat:Filter(Card.IsControler,nil,1-tp)
			mat:Sub(omat)
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			if #omat>0 and Duel.Remove(omat,POS_FACEUP,
				REASON_EFFECT+REASON_TEMPORARY)>0 then
				local og=omat:Filter(Card.IsLoc,nil,"R")
				local oc=og:GetFirst()
				local fid=c:GetFieldID()
				while oc do
					oc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000
						+RESET_PHASE+PHASE_END,0,1,fid)
					oc=og:GetNext()
				end
				og:KeepAlive()
				local e1=MakeEff(c,"FC")
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetCountLimit(1)
				e1:SetLabel(fid)
				e1:SetLabelObject(og)
				e1:SetCondition(cm.ocon11)
				e1:SetOperation(cm.oop11)
				Duel.RegisterEffect(e1,tp)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,c,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.onfil11(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.ocon11(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.onfil11,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else
		return true
	end
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	local sg=g:Filter(cm.onfil11,nil,e:GetLabel())
	g:DeleteGroup()
	if #sg>0 then
		local tc=sg:Select(1-tp,1,1,nil):GetFirst()
		while tc do
			if Duel.ReturnToField(tc) then
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(1)
				tc:RegisterEffect(e1)
			end
			sg:RemoveCard(tc)
			tc=sg:Select(1-tp,1,1,nil):GetFirst()
		end
	end
	e:Reset()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.cfil21(c)
	if not c:IsAbleToRemoveAsCost() then
		return false
	end
	if c:IsLoc("G") then
		return c:IsSetCard(0x12d2)
	else
		return not c:IsCanBeFusionMaterial()
	end
end
function cm.cfun21(sg,tp,fg)
	local gg=sg:Filter(Card.IsLoc,nil,"G")
	local mg=sg:Filter(Card.IsLoc,nil,"M")
	return #gg>0 and #gg==#mg and mg:GetClassCount(Card.GetAttribute)==#mg
		and Duel.GetLocationCountFromEx(tp,tp,mg,TYPE_FUSION)<=#mg
		and cm.cfun22(mg,fg)
end
function cm.cfun22(mg,fg)
	local tc=mg:GetFirst()
	while tc do
		local att=tc:GetOriginalAttribute()
		if not fg:IsExists(Card.IsAttribute,1,nil,att) then
			return false
		end
		tc=mg:GetNext()
	end
	return true
end
function cm.cfil22(c,tp,g,sg,fg)
	sg:AddCard(c)
	local res=false
	if cm.cfun21(sg,tp,fg) then
		res=true
	elseif #sg<2*Duel.GetLocationCountFromEx(tp) then
		res=g:IsExists(cm.cfil22,1,sg,tp,g,sg,fg)
	end
	sg:RemoveCard(c)
	return res
end
function cm.tfil2(c,e,tp)
	return c:IsSetCard(0x12d2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local fg=Duel.GMGroup(cm.tfil2,tp,"E",0,nil,e,tp)
	local g=Duel.GMGroup(cm.cfil21,tp,"G","M",nil)
	if chk==0 then
		if e:GetLabel()<1 then
			return false
		end
		e:SetLabel(0)
		local sg=Group.CreateGroup()
		return g:IsExists(cm.cfil22,1,nil,tp,g,sg,fg)
	end
	e:SetLabel(0)
	local sg=Group.CreateGroup()
	while true do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local init=(cm.cfun21(sg,tp,fg) and 0) or 1
		local tg=g:FilterSelect(tp,cm.cfil22,init,1,sg,tp,g,sg,fg)
		if #tg>0 then
			sg:Merge(tg)
		else
			break
		end
	end
	local mg=sg:Filter(Card.IsLoc,nil,"M")
	mg:KeepAlive()
	e:SetLabelObject(mg)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.ofil2(c,sg,fg,mg)
	sg:AddCard(c)
	local res=false
	if #sg<#mg then
		res=fg:IsExists(cm.ofil2,1,sg,sg,fg,mg)
	else
		res=cm.ofun2(sg,mg)
	end
	sg:RemoveCard(c)
	return res
end
function cm.ofun2(sg,mg)
	return #sg>0 and sg:GetClassCount(Card.GetCode)==#sg
		and Duel.GetLocationCountFromEx(tp)>=#mg and cm.cfun22(mg,sg)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local mg=g:Clone()
	g:DeleteGroup()
	local fg=Duel.GMGroup(cm.tfil2,tp,"E",0,nil,e,tp)
	local sg=Group.CreateGroup()
	if not fg:IsExists(cm.ofil2,1,nil,sg,fg,mg) then
		return
	end
	while #sg<#mg do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=fg:FilterSelect(tp,cm.ofil2,1,1,sg,sg,fg,mg)
		sg:Merge(tg)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end