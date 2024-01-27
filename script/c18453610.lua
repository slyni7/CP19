--시저크로스 폭스
local m=18453610
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_WATER,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_FIRE}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	local res=Duel.RockPaperScissors()
	if res==tp and Duel.IsPlayerCanDraw(rp,1) and Duel.SelectYesNo(tp,aux.Stringid(m,00)) then
		Duel.HintSelection(Group.FromCards(c))
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.ocop11)
	elseif res==1-tp and Duel.IsPlayerCanDraw(rp,1) and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		Duel.HintSelection(Group.FromCards(c))
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,cm.ocop11)
	end
end
function cm.ocop11(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end