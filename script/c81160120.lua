--그림자무리의 악마
function c81160120.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c81160120.mat),2,2)
	
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81160120,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81160120)
	e1:SetCondition(c81160120.cn1)
	e1:SetTarget(c81160120.tg1)
	e1:SetOperation(c81160120.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--leave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81160120,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81160121)
	e3:SetCost(c81160120.co2)
	e3:SetTarget(c81160120.tg2)
	e3:SetOperation(c81160120.op2)
	c:RegisterEffect(e3)
end

--material
function c81160120.mat(c)
	return c:IsSetCard(0xcb3) and not c:IsCode(81160120)
end

--summon
function c81160120.filter1(c,ec)
	if c:IsSetCard(0xcb3) and c:IsType(TYPE_TUNER)then
		if c:IsLocation(LOCATION_MZONE) then
			return ec:GetLinkedGroup():IsContains(c)
		else
			return bit.band(ec:GetLinkedGroup(c:GetPreviousControler()),bit.lshift(0x1,c:GetPreviousSequence()))~=0
		end
	end
end
function c81160120.cn1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81160120.filter1,1,nil,e:GetHandler())
end
function c81160120.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81160120.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--leave
function c81160120.filter2(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcb3)
end
function c81160120.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81160120.filter2,tp,LOCATION_GRAVE,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81160120.filter2,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81160120.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81160120.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

