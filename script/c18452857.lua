--컬러큐브 오렌지
local m=18452857
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	c:EnableCounterPermit(0x2d7)
	local e2=MakeEff(c,"F","S")
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetTargetRange(LSTN("S"),0)
	e2:SetValue(1)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","S")
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCountLimit(1)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"I","S")
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetDescription(aux.Stringid(m,2))
	WriteEff(e5,5,"CTO")
	c:RegisterEffect(e5)
end
cm.mana_list={ATTRIBUTE_EARTH}
function cm.tar2(e,c)
	return c:GetType()&TYPE_SPELL+TYPE_CONTINUOUS==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSetCard("컬러큐브") and not c:IsCode(m)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
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
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x2d7,1)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:GetCounter(0x2d7)>0 then
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_EXTRA_SQUARE_MANA)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			e1:SetLabel(c:GetCounter(0x2d7))
			e1:SetValue(cm.oval41)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.oval41(e,c)
	local t={}
	local ct=e:GetLabel()
	for i=1,ct do
		table.insert(t,ATTRIBUTE_EARTH)
	end
	return table.unpack(t)
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(10000)
	return true
end
function cm.tfil5(c,ct)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsAbleToHand() and c:IsLevelBelow(ct)
		and (c:IsAttribute(ATTRIBUTE_EARTH) or c:IsHasSquareMana(ATTRIBUTE_EARTH))
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x2d7)
	if chk==0 then
		if e:GetLabel()~=10000 then
			return false
		end
		e:SetLabel(0)
		return Duel.IEMCard(cm.tfil5,tp,"D",0,1,nil,ct)
	end
	e:SetLabel(ct)
	Duel.SendtoGrave(c,REASON_COST)
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil5,tp,"D",0,1,1,nil,ct)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end