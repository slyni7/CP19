--Angel Notes - 퍼포먼스
function c76859111.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCountLimit(1,76859111+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c76859111.tg1)
	e1:SetOperation(c76859111.op1)
	c:RegisterEffect(e1)
end
function c76859111.tfilter11(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER)
end
function c76859111.tfilter12(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_SPELL)
end
function c76859111.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(c76859111.tfilter11,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingTarget(c76859111.tfilter12,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c76859111.tfilter11,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c76859111.tfilter12,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c76859111.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		local tc=sg:GetFirst()
		while tc do
			if tc:IsType(TYPE_MONSTER) then
				local def=tc:GetTextDefense()
				if def>0 then
					Duel.SetLP(tp,Duel.GetLP(tp)-def)
				end
			end
			tc=sg:GetNext()
		end
	end
end