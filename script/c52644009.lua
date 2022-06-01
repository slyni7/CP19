--스타폴른 사이트
function c52644009.initial_effect(c)
	--1턴에 1번밖에 발동 불가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,52644009+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--공격력 +800
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c52644009.tg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--패 버리고 서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52644009,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,52644009)
	e3:SetCost(c52644009.thcost)
	e3:SetTarget(c52644009.thtg)
	e3:SetOperation(c52644009.thop)
	c:RegisterEffect(e3)
end
function c52644009.tg(e,c)
	return c:IsSetCard(0x5f4) and c:IsRace(RACE_PYRO)
end
function c52644009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c52644009.thfilter(c)
	return c:IsSetCard(0x5f4) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c52644009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c52644009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c52644009.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c52644009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
