--인트로 인디고
local m=18453112
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetCondition(aux.exccon)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2e2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil21(c)
	return c:IsCustomType(CUSTOMTYPE_DIFFUSION) and c:IsSetCard(0x2e2) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.tfil22(c)
	return not c:IsCustomType(CUSTOMTYPE_DIFFUSION) and c:IsSetCard(0x2e2) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil21,tp,"G",0,1,nil) and Duel.IETarget(cm.tfil22,tp,"G",0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.STarget(tp,cm.tfil21,tp,"G",0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.STarget(tp,cm.tfil22,tp,"G",0,1,1,nil)
	g1:Merge(g2)
	Duel.SOI(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g~=2 then
		return
	end
	if Duel.SendtoDeck(g,nil,0,REASON_EFFECT)==2 then
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end