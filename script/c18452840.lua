--헤븐 다크사이트 -영화-
local m=18452840
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil1(c,chain)
	return (c:IsSetCard(0x2d9) or (chain>2 and c:IsAttack(0))) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local chain=Duel.GetCurrentChain()
	if chk==0 then
		local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil,chain+1)
		return g:GetClassCount(Card.GetCode)>=chain
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,chain-1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local chain=Duel.GetCurrentChain()
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil,chain)
	if g:GetClassCount(Card.GetCode)>=chain-1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,chain-1,chain-1)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end