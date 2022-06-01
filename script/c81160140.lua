--그림자의 재언
--카드군 번호: 0xcb3
function c81160140.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--리쿠르트
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81160140,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81160140.cn2)
	e2:SetCost(c81160140.co2)
	e2:SetTarget(c81160140.tg2)
	e2:SetOperation(c81160140.op2)
	c:RegisterEffect(e2)
	
	--회수
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81160140,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,81160140)
	e3:SetCost(c81160140.co3)
	e3:SetTarget(c81160140.tg3)
	e3:SetOperation(c81160140.op3)
	c:RegisterEffect(e3)
	
	--효과 개변
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(81160140)
	e4:SetRange(0x100)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
end

--리쿠르트
function c81160140.cfilter(c)
	return c:GetSequence()<5
end
function c81160140.cn2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c81160140.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81160140.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c81160140.filter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)	and c:IsSetCard(0xcb3) and c:IsLevelBelow(4)
end
function c81160140.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81160140.filter0,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81160140.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81160140.filter0,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--회수
function c81160140.filter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c81160140.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81160140.filter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81160140.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81160140.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c81160140.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end


