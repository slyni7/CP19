--그 만용이 불나방과 같을지라도
local m=18453334
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddBraveProcedure(c,nil,3,6)
	local e1=MakeEff(c,"I","M")
	WriteEff(e1,1,"CO")
	c:RegisterEffect(e1)
end
cm.custom_type=CUSTOMTYPE_BRAVE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local bz=aux.BurningZone[tp]
	local og=Group.CreateGroup()
	for i=1,#bz do
		og:AddCard(bz[i])
	end
	if chk==0 then
		return og:IsExists(Card.IsAbleToDeckAsCost,3,nil) and Duel.CheckLPCost(tp,2700)
	end
	local tg=og:FilterSelect(tp,Card.IsAbleToDeckAsCost,3,3,nil)
	aux.EraseFromBurningZone(tg)
	Duel.SendtoDeck(tg,nil,1,REASON_COST)
	Duel.SortDeckbottom(tp,tp,3)
	Duel.PayLPCost(tp,2700)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_BRAVE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(2700)
		c:RegisterEffect(e1)
	end
end