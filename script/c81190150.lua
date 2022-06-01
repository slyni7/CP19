--청홍의 메아리
--카드군 번호: 0xcb6
function c81190150.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81190150+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81190150.co1)
	e1:SetTarget(c81190150.tg1)
	e1:SetOperation(c81190150.op1)
	c:RegisterEffect(e1)
end

--발동
function c81190150.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_COST,e:GetHandler())
end
function c81190150.filter0(c)
	return c:IsAbleToHand() and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_FIRE)
	and c:IsLevelBelow(6) and not c:IsType(TYPE_TUNER)
end
function c81190150.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190150.filter0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81190150.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81190150.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
