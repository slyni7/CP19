--바벨의 도서관 장서 A.
local m=99970175
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Error.
	YuL.TheLibraryofBabel(c)
	
	--회수 + 창조
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.rtgtg)
	e1:SetOperation(cm.rtgop)
	c:RegisterEffect(e1)

end

--회수 + 창조
function cm.rtgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3e)
end
function cm.rtgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.rtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rtgfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.rtgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.rtgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,99970171)
		Duel.SendtoHand(token,nil,REASON_RULE)
		Duel.ConfirmCards(1-tp,token)
	end
end
	