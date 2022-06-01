--举府胶 府挪甸
local m=18453011
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","G")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
function cm.tfil2(c,e,tp)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE)
		and (c:IsAbleToHand() or (Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil,e,tp)
	end
end
function cm.ofil2(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup() and c:IsHasExactSquareMana(ATTRIBUTE_FIRE)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local th=tc:IsAbleToHand()
		local sp=Duel.GetLocCount(tp,"M")>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then
			op=Duel.SelectOption(tp,1190,1152)
		elseif th then
			op=0
		else
			op=1
		end
		if op==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		local ct=0
		local dg=Duel.GMGroup(aux.TRUE,tp,0,"O",nil)
		while ct<#dg do
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
			local sg=Duel.SMCard(tp,cm.ofil2,tp,"M",0,0,1,nil)
			local sc=sg:GetFirst()
			if sc then
				if ct<1 then
					Duel.BreakEffect()
				end
				ct=ct+1
				local e1=MakeEff(c,"S")
				e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.oval21)
				sc:RegisterEffect(e1)
			else
				break
			end
		end
		if ct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local og=dg:Select(tp,ct,ct,nil)
			Duel.Destroy(og,REASON_EFFECT)
		end
	end
end
function cm.oval21(e,c)
	return ATTRIBUTE_FIRE
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LSTN("HO"))
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*100)
end
function cm.ofil3(c)
	return c:IsSetCard("举府胶") and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsFaceup()
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,0,LSTN("HO"))
	if Duel.Damage(1-tp,ct*100,REASON_EFFECT)>0 then
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
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	c:CreateEffectRelation(e)
end
function cm.tfil41(c,e,tp)
	return c:IsCode(18453009) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tfil42(c)
	return c:IsCode(18453009) and c:IsFaceup()
end
function cm.tfil43(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil41,tp,"D",0,nil,e,tp)
	if Duel.IEMCard(cm.tfil42,tp,"M",0,1,nil) then
		local sg=Duel.GMGroup(cm.tfil43,tp,"G",0,nli,e,tp)
		g:Merge(sg)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and #g>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"DG")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>0 then
		local g=Duel.GMGroup(cm.tfil41,tp,"D",0,nil,e,tp)
		if Duel.IEMCard(cm.tfil42,tp,"M",0,1,nil) then
			local sg=Duel.GMGroup(cm.tfil43,tp,"G",0,nli,e,tp)
			g:Merge(sg)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
	if c:IsRelateToEffect(e) then
		local e1=MakeEff(c,"FC","R")
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.ocon41)
		e1:SetOperation(cm.oop41)
		c:RegisterEffect(e1)
	end
end
function cm.ocon41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocCount(tp,"S")>0 and c:IsSSetable()
end
function cm.oop41(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SSet(tp,c)
end