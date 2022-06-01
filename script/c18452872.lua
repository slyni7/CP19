--도마뱀 자각의 선율
local m=18452872
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToGraveAsCost,tp,"H",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,Card.IsAbleToGraveAsCost,tp,"H",0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tfil1(c)
	return c:GetAttack()<=1800 and c:GetDefense()>=1500 and c:IsRace(RACE_DRAGON) and c:IsAbleToHand()
end
function cm.tfun1(g)
	return g:IsExists(Card.IsCode,1,nil,18452865)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	if chk==0 then
		return g:CheckSubGroup(cm.tfun1,1,2)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	if not g:CheckSubGroup(cm.tfun1,1,2) then
		return false
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,cm.tfun1,false,1,2)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end