--[ Pneumamancy ]
local m=99970378
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	local e1=YuL.Equip(c,nil,aux.FBF(Card.IsSetCard,0xe12),nil,nil,nil,cm.pneu_op)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_TOHAND+CATEGORY_SEARCH)
	
	--효과 파괴 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	
end

--영령술
function cm.thfil(c)
	return c:IsSetCard(0xe12) and not c:IsCode(m) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function cm.pneu_op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
