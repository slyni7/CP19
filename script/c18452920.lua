--새 테마
local m=18452920
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tfil1(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsLevelBelow(4) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end