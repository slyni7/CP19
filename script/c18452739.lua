--할로위즈 네레이아
local m=18452739
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=MakeEff(c,"F","E")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetValue(SUMMON_TYPE_LINK)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","R")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,m+1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function cm.nfil11(c)
	return c:IsSetCard(0x2d2) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function cm.nfun11(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x2d2)
end
function cm.nfun12(sg,tp,lc,gf)
	return aux.LCheckGoal(sg,tp,lc,gf) and sg:FilterCount(Card.IsControler,nil,1-tp)<2
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local mg=aux.GetLinkMaterials(tp,nil,c)
	local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
	local exchk=Duel.IEMCard(cm.nfil11,tp,"H",0,1,nil)
	local exg=Duel.GMGroup(aux.LConditionFilter,tp,0,"M",nil,nil,c)
	if exchk then
		mg:Merge(exg)
	end
	if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then
		return false
	end
	Duel.SetSelectedCard(fg)
	return mg:CheckSubGroup(cm.nfun12,2,2,tp,c,cm.nfun11)
end
function cm.tfil1(c,g)
	return g:IsContains(c)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=aux.GetLinkMaterials(tp,nil,c)
	local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_LMATERIAL)
	Duel.SetSelectedCard(fg)
	local exchk=Duel.IEMCard(cm.nfil11,tp,"H",0,1,nil)
	local exg=Duel.GMGroup(aux.LConditionFilter,tp,0,"M",nil,nil,c)
	local lg=mg:Clone()
	if exchk then
		mg:Merge(exg)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	local can=Duel.GetCurrentChain()<1
	local sg=mg:SelectSubGroup(tp,cm.nfun12,can,2,2,tp,c,cm.nfun11)
	if sg then
		if sg:IsExists(cm.tfil1,1,lg,exg) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local dg=Duel.SMCard(tp,cm.nfil11,tp,"H",0,1,1,nil)
			Duel.SendtoGrave(dg,REASON_COST+REASON_DISCARD)
		end
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else
		return false
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local tg=g:Filter(Card.IsControler,nil,1-tp)
	local tc=tg:GetFirst()
	if tc then
		g:Sub(tg)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		local e2=MakeEff(c,"S","M")
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetReset(RESET_EVENT+0xff0000)
		e2:SetValue(tc:GetAttribute())
		c:RegisterEffect(e2)
	end
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
	g:DeleteGroup()
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
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end
function cm.tfil3(c,tp)
	return (c:IsLoc("H") or c:IsFaceup()) and c:IsSetCard(0x2d2) and Duel.GetMZoneCount(tp,c)>0
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and Duel.IEMRemoveCard(cm.tfil3,tp,"HO",0,1,nil,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SMRemoveCard(tp,cm.tfil3,tp,"HO",0,1,1,nil,tp)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end