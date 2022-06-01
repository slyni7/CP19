--천계의 심해
--카드군 번호: 0xcb0
function c81130120.initial_effect(c)

	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81130120,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,81130120)
	e1:SetTarget(c81130120.tg1)
	e1:SetOperation(c81130120.op1)
	c:RegisterEffect(e1)
	
	--효과 무효
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81130120,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,81130121)
	e2:SetCondition(c81130120.cn2)
	e2:SetCost(c81130120.co2)
	e2:SetTarget(c81130120.tg2)
	e2:SetOperation(c81130120.op2)
	c:RegisterEffect(e2)
end

--서치
function c81130120.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb0) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81130120.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81130120.filter0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81130120.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81130120.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--프리체인
function c81130120.cn2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
end
function c81130120.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsDiscardable()
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c81130120.filter1(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsSetCard(0xcb0) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c81130120.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81130120.filter1(chkc)
	end
	if chk==0 then
		return not re:GetHandler():IsStatus(STATUS_DISABLED)
		and Duel.IsExistingTarget(c81130120.filter1,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81130120.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c81130120.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.NegateEffect(ev)~=0 and tc:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		if tc:IsPreviousLocation(LOCATION_EXTRA) then
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
	end
end


