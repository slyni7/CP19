--정령계 판타지아
local m=18452786
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTR("MG",0)
	e2:SetValue(aux.tgoval)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
end
function cm.ofil1(c)
	return c:IsCode(18452771) and c:IsAbleToHand()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.tar2(e,c)
	return (c:IsSetCard("정령") and not c:IsSummonableCard())
		or c:IsCode(47606319,61901281,99234526,73001017,218704,74823665,18452771)
end