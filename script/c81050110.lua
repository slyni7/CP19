--전염되는 장기

function c81050110.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81050110)
	e2:SetCondition(c81050110.ecn)
	e2:SetCost(c81050110.eco)
	e2:SetTarget(c81050110.etg)
	e2:SetOperation(c81050110.eop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c81050110.quickcon)
	c:RegisterEffect(e3)
	
	--search & to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,81050111)
	e4:SetCondition(c81050110.vcn)
	e4:SetTarget(c81050110.vtg)
	e4:SetOperation(c81050110.vop)
	c:RegisterEffect(e4)
end

--destroy
function c81050110.tfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCode(81050000) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
	and c:IsFaceup()
end
function c81050110.ecn(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c81050110.tfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81050110.quickcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81050110.tfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c81050110.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca6) and c:IsAbleToRemoveAsCost()
end
function c81050110.eco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_MZONE+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81050110.cfilter,tp,loc,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81050110.cfilter,tp,loc,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81050110.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsDestructable()
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81050110.eop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not e:GetHandler():IsRelateToEffect(e) then
		return false
	end
	if tc:IsRelateToEffect(e) and e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


--salvage
function c81050110.vcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c81050110.sfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x1ca6) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81050110.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81050110.sfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81050110.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81050110.sfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
