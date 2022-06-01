--정령 교신
local m=18452785
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,m)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.tfil11(c,tp)
	return ((c:IsLevel(4) and c:IsSetCard("정령") and not c:IsSummonableCard())
		or c:IsCode(47606319,61901281,99234526,73001017,218704,74823665,18452771)) and c:IsAbleToHand()
		and Duel.IEMCard(cm.tfil12,tp,"D",0,1,c,tp,c:GetOriginalCode())
end
function cm.tfil12(c,tp,code)
	if not c:IsAbleToGrave()
		or Duel.IEMCard(cm.tfil13,tp,"G",0,1,nil,c:GetAttribute()) then
		return false
	end
	if code==13522325 or code==74823665 then
		return c:IsAttribute(ATTRIBUTE_FIRE)
	end
	if code==73001017 or code==12800777 then
		return c:IsAttribute(ATTRIBUTE_WIND)
	end
	if code==40916023 or code==218704 then
		return c:IsAttribute(ATTRIBUTE_WATER)
	end
	if code==47606319 or code==76305638 then
		return c:IsAttribute(ATTRIBUTE_EARTH)
	end
	if code==99234526 or code==48596760 then
		return c:IsAttribute(ATTRIBUTE_DARK)
	end
	if code==61901281 or code==17257342 then
		return c:IsAttribute(ATTRIBUTE_LIGHT)
	end
	if code==18452771 then
		return ((c:IsLevel(4) or c:IsRank(4)) and c:IsSetCard("정령") and not c:IsSummonableCard())
			or c:IsCode(47606319,61901281,99234526,73001017,218704,74823665)
	end
	return false
end
function cm.tfil13(c,att)
	return c:GetAttribute()&att>0
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil,tp)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.SMCard(tp,cm.tfil12,tp,"D",0,1,1,nil,tp,tc:GetOriginalCode())
		if #sg>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
function cm.cfil2(c)
	return c:IsType(TYPE_MONSTER) and not c:IsSummonableCard() and c:IsAbleToDeckAsCost()
end
function cm.cost2(e,tp,eg,pe,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost() and Duel.IEMCard(cm.cfil2,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"G",0,1,1,nil)
	g:AddCard(c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.tfil2(c)
	return c:IsCode(18452771) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end