--☔☔☔
local m=99970241
local cm=_G["c"..m]
function cm.initial_effect(c)

	--서치 / 덤핑
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

end

--서치 / 덤핑
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,4) end
end
function cm.filter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xe01)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,4) then return end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(cm.filter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,cm.filter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		else
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_REVEAL)
			Duel.ShuffleDeck(tp)
		end
	end
end
