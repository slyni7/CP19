--페르마의 마지막 정리
local m=18452791
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_MODULE),nil,3,5,nil)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo","M")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_EQUIP)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetCountLimit(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_MODULE)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocCount(tp,"S")
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G")
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,"G",0,1,nil) and ft>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local ct=math.min(ft,3)
	local g=Duel.STarget(tp,aux.TRUE,tp,"G",0,1,ct,nil)
	Duel.SOI(0,CATEGORY_EQUIP,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocCount(tp,"S")
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if c:IsFaceup() and c:IsRelateToEffect(e) and ft>0 and #g>0 then
		if #g>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			g=g:Select(tp,ft,ft,nil)
		end
		local tc=g:GetFirst()
		while tc do
			Duel.Equip(tp,tc,c)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.oval21)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
	local e2=MakeEff(c,"F")
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(cm.otar22)
	Duel.RegisterEffect(e2,tp)
end
function cm.oval21(e,c)
	return e:GetOwner()==c
end
function cm.otar22(e,c,tp,sumtp,sumpos)
	return sumtp&SUMMON_TYPE_MODULE==SUMMON_TYPE_MODULE
end
function cm.cfil3(c,g)
	return c:IsAbleToGraveAsCost() and g:IsContains(c)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetEquipGroup()
	if chk==0 then
		return Duel.IEMCard(cm.cfil3,tp,"S",0,3,nil,g)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SMCard(tp,cm.cfil3,tp,"S",0,3,3,nil,g)
	Duel.SendtoGrave(sg,REASON_COST)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToDeck,tp,0,"O",1,nil)
			and Duel.IEMCard(Card.IsAbleToDeck,tp,0,"H",1,nil)
			and Duel.IEMCard(Card.IsAbleToDeck,tp,0,"G",1,nil)
	end
	Duel.SOI(0,CATEGORY_DECK,nil,3,0,"OHG")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GMGroup(Card.IsAbleToDeck,tp,0,"H",nil)
	local g2=Duel.GMGroup(Card.IsAbleToDeck,tp,0,"O",nil)
	local g3=Duel.GMGroup(Card.IsAbleToDeck,tp,0,"G",nil)
	if #g1>0 and #g2>0 and #g3>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg1=g1:RandomSelect(tp,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg3=g3:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.HintSelection(sg1)
		Duel.SendtoDeck(sg1,nil,2,REASON_EFFECT)
	end
end
function cm.tfil4(c,e,tp)
	return c:IsLevelBelow(8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil4(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil4,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil4,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end