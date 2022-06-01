--스타피시 이퀄
local m=18453135
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(2,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	cm.todeck_effect=e1
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2e3) and c:IsAbleToHand() and c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	local mg=Duel.GMGroup(aux.TRUE,tp,"M",0,nil)
	local mc=mg:GetFirst()
	while mc do
		local og=mc:GetOverlayGroup()
		if og and #og>0 then
			local tg=og:Filter(cm.tfil1,nil)
			g:Merge(tg)
		end
		mc=mg:GetNext()
	end
	if chk==0 then
		return #g>0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DX")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(cm.tfil1,tp,"D",0,nil)
	local mg=Duel.GMGroup(aux.TRUE,tp,"M",0,nil)
	local mc=mg:GetFirst()
	while mc do
		local og=mc:GetOverlayGroup()
		if og and #og>0 then
			local tg=og:Filter(cm.tfil1,nil)
			g:Merge(tg)
		end
		mc=mg:GetNext()
	end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,2,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end