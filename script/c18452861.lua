--컬러큐브 바이올렛
local m=18452861
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	c:EnableCounterPermit(0x2d7)
	local e2=MakeEff(c,"I","S")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"I","S")
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetDescription(aux.Stringid(m,2))
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
cm.mana_list={ATTRIBUTE_DARK}
function cm.tfil1(c,e,tp)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and Duel.GetLocCount(tp,"M")>0
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil1(chkc,e,tp)
	end
	if chk==0 then
		return true
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,cm.tfil1,tp,"G",0,0,1,nil,e,tp)
	if #g>0 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetProperty(0)
		e:SetCategory(0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("M") and chkc:IsFaceup()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsFaceup,tp,"M",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.STarget(tp,Card.IsFaceup,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_COUNTER,nil,1,tp,0x2d7)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x2d7,1)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:GetCounter(0x2d7)>0 then
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			e1:SetLabel(c:GetCounter(0x2d7))
			e1:SetValue(cm.oval21)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.oval21(e,c)
	local t={}
	local ct=e:GetLabel()
	for i=1,ct do
		table.insert(t,ATTRIBUTE_DARK)
	end
	return table.unpack(t)
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function cm.tfil3(c,ct)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsAbleToHand() and c:IsLevelBelow(ct)
		and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsHasSquareMana(ATTRIBUTE_DARK))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x2d7)
	if chk==0 then
		if e:GetLabel()~=10000 then
			return false
		end
		e:SetLabel(0)
		return Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil,ct)
	end
	e:SetLabel(ct)
	Duel.SendtoGrave(c,REASON_COST)
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil,ct)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end