--할로위즈 프리즘
local m=18452747
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","F")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(m,0))
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetDescription(aux.Stringid(m,1))
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","F")
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_POSITION)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"I","G")
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_POSITION)
	e5:SetCountLimit(1,m+1)
	WriteEff(e5,5,"CTO")
	c:RegisterEffect(e5)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)<1 and Duel.IEMRemoveACCard(nil,tp,"H",0,1,nil)
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_END,0,1)
	local g=Duel.SMRemoveACCard(tp,nil,tp,"H",0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tfil2(c)
	return c:IsSetCard(0x2d2) and c:IsLevelBelow(4)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMToHandMon(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.SMAToHandMon(tp,cm.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMRemoveCard(Card.IsRace,tp,"D",0,1,nil,RACE_ZOMBIE)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.SMRemoveCard(tp,Card.IsRace,tp,"D",0,1,1,nil,RACE_ZOMBIE)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tfil4(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2d2) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GMFaceupGroup(Card.IsCanBeFusionMaterial,tp,0,"M",nil)
		mg1:Merge(mg2)
		local res=Duel.IEMCard(cm.tfil4,tp,"E",0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IEMCard(cm.tfil4,tp,"E",0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsNotImmuneToEffect,nil,e)
	local mg2=Duel.GMFaceupGroup(Card.IsCanBeFusionMaterial,tp,0,"M",nil)
	mg1:Merge(mg2)
	local sg1=Duel.GMGroup(cm.tfil4,tp,"E",0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:Getvalue()
		sg2=Duel.GMGroup(cm.tfil4,tp,"E",0,nil,e,tp,mg3,mf,chkf)
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
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
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
			while oc do
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_CANNOT_TRIGGER)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
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