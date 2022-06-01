--EE(이터널 엘릭서) 노바
function c18453252.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,18453252+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c18453252.target)
	e1:SetOperation(c18453252.activate)
	c:RegisterEffect(e1)
end
function c18453252.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2ea) and c:IsFaceup() and c:IsAbleToHand()
end
function c18453252.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_REMOVED and c18453252.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18453252.filter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c18453252.filter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c18453252.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
