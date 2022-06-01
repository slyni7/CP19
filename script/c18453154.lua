--举府胶 聪福官唱
local m=18453154
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetCountLimit(1,m+1)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.nfil2(c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil2,tp,"O",0,1,nil)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	c:SetStatus(STATUS_EFFECT_ENABLED,true)
end
function cm.tfil21(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function cm.tfil22(c,e,tp,mg,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCustomType(CUSTOMTYPE_SQUARE) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil,chkf)
end
function cm.tfil23(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup() and c:IsHasExactSquareMana(ATTRIBUTE_DIVINE)
end
function cm.tfil24(c)
	return not (c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE))
end
function cm.tfun21(tp,sg,fc)
	return sg:FilterCount(cm.tfil24,nil)<1
end
function cm.tfun22(sg)
	return sg:FilterCount(cm.tfil24,nil)<1
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GMGroup(cm.tfil21,tp,"D",0,nil)
		mg1:Merge(mg2)
		local ag=Duel.GMGroup(cm.tfil23,tp,"M",0,nil)
		local check=#ag>0
		if not check then
			aux.FCheckAdditional=cm.tfun21
			aux.GCheckAdditional=cm.tfun22
		end
		local res=Duel.IEMCard(cm.tfil22,tp,"E",0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IEMCard(cm.tfil22,tp,"E",0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.ofil21(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.ofil22(c,e)
	return not c:IsSetCard("举府胶")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.ofil21,nil,e)
	local mg2=Duel.GMGroup(cm.tfil21,tp,"D",0,nil):Filter(cm.ofil21,nil,e)
	mg1:Merge(mg2)
	local ag=Duel.GMGroup(cm.tfil23,tp,"M",0,nil)
	local check=#ag>0
	if not check then
		aux.FCheckAdditional=cm.tfun21
		aux.GCheckAdditional=cm.tfun22
	end
	local sg1=Duel.GMGroup(cm.tfil22,tp,"E",0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GMGroup(cm.tfil22,tp,"E",0,nil,e,tp,mg3,mf,chkf)
	end
	if #sg1>0 or (sg2~=nil and #sg2>0) then
		local sg=sg1:Clone()
		if sg2 then
			sg:Merge(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if not check then
				aux.FCheckAdditional=cm.tfun21
				aux.GCheckAdditional=cm.tfun22
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			aux.FCheckAdditional=nil
			aux.GCheckAdditional=nil
			tc:SetMaterial(mat1)
			if mat1:IsExists(cm.ofil22,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
				local qg=ag:Select(tp,1,1,nil)
				local qc=qg:GetFirst()
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.oval21)
				qc:RegisterEffect(e1)				
			end
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
end
function cm.oval21(e,c)
	return ATTRIBUTE_DIVINE
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tfil3(c)
	return c:IsSetCard("举府胶") and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	local g=Duel.GMGroup(Card.IsAbleToDeck,tp,"H",0,nil)
	if #g>0 then
		Duel.SOI(0,CATEGORY_TODECK,g,#g,0,0)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.ofil3(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GMGroup(Card.IsAbleToDeck,tp,"H",0,nil)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
	end
	local ag=Duel.GMGroup(cm.tfil3,tp,"D",0,nil)
	if #ag<1 then
		return
	end
	local hg=Group.CreateGroup()
	local ct=1
	while #ag>0 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=ag:Select(tp,ct,1,nil)
		ct=0
		local tc=tg:GetFirst()
		if not tc then
			break
		end
		hg:AddCard(tc)
		local rg=ag:Filter(Card.IsCode,nil,tc:GetCode())
		ag:Sub(rg)
	end
	if Duel.SendtoHand(hg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,hg)
		local sg=Duel.GMGroup(cm.ofil3,tp,"M",0,nil)
		local sc=sg:GetFirst()
		if sc then
			Duel.BreakEffect()
		end
		while sc do
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.oval21)
			sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
	end
end
function cm.cfil4(c)
	return c:IsSetCard("举府胶") and c:IsType(TYPE_SPELL) and not c:IsCode(m) and c:IsAbleToGraveAsCost() and (c:IsLoc("D") or c:IsFaceup())
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.cfil4,tp,"SD",0,nil)
	if chk==0 then
		return c:IsAbleToRemoveAsCost() and g:GetClassCount(Card.GetCode)>6
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
	local sg=Group.CreateGroup()
	for i=1,7 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		sg:AddCard(tc)
		local rg=g:Filter(Card.IsCode,nil,tc:GetCode())
		g:Sub(rg)
	end
	Duel.SendtoGrave(sg,REASON_COST)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x11,2500,2000,8,RACE_PYRO,ATTRIBUTE_FIRE)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x11,2500,2000,8,RACE_PYRO,ATTRIBUTE_FIRE) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SET_SQUARE_MANA)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(cm.oval41)
		c:RegisterEffect(e1)
		local e3=MakeEff(c,"S")
		e3:SetCode(EFFECT_ADD_CUSTOM_TYPE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e3:SetValue(CUSTOMTYPE_SQUARE)
		c:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
	local e4=MakeEff(c,"FC")
	e4:SetCode(EVENT_SSET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetOperation(cm.oop44)
	Duel.RegisterEffect(e4,tp)
end
function cm.oval41(e,c)
	return ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT,ATTRIBUTE_WIND,ATTRIBUTE_WATER,ATTRIBUTE_DARK,0x0,ATTRIBUTE_DIVINE
end
function cm.oop44(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentPhase()==PHASE_END then
		local tc=eg:GetFirst()
		while tc do
			if tc:IsSetCard("举府胶") and tc:IsControler(tp) and tc:IsType(TYPE_QUICKPLAY) then
				Duel.Hint(HINT_CARD,0,m)
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
			tc=eg:GetNext()
		end
	end
end