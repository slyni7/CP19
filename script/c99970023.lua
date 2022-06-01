--H. Enchanter: 3
function c99970023.initial_effect(c)

	--특수 소환
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_FIELD)
	es:SetCode(EFFECT_SPSUMMON_PROC)
	es:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	es:SetRange(LOCATION_HAND)
	es:SetCondition(c99970023.spcon)
	c:RegisterEffect(es)

	--오버레이
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99970023,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,99970023)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c99970023.target)
	e3:SetOperation(c99970023.operation)
	c:RegisterEffect(e3)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,99970023)
	e2:SetCondition(c99970023.thcon)
	e2:SetTarget(c99970023.thtg)
	e2:SetOperation(c99970023.thop)
	c:RegisterEffect(e2)
	
end

--특수 소환
function c99970023.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32)
end
function c99970023.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c99970023.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

--오버레이
function c99970023.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xd32)
end
function c99970023.filter2(c)
	return c:IsSetCard(0xd33) or (c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER))
end
function c99970023.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c99970023.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c99970023.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99970023,2))
	Duel.SelectTarget(tp,c99970023.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99970023,3))
	local g=Duel.SelectTarget(tp,c99970023.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c99970023.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc1=g:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if tc1 and tc1:IsFaceup() and not tc1:IsImmuneToEffect(e) and g2:GetCount()>0 then
		Duel.Overlay(tc1,g2)
	end
end

--서치
function c99970023.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c99970023.thfilter(c)
	return c:IsSetCard(0xd33) and c:IsAbleToHand()
end
function c99970023.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970023.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970023.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99970023.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
