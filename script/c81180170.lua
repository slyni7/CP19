--KMS(메탈 블러드) 라이프치히
--카드군 번호: 0xcb5
function c81180170.initial_effect(c)

	--덤핑
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81180170,0))
	e1:SetCategory(CATEGORY_TO_GRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,81180170)
	e1:SetTarget(c81180170.tg1)
	e1:SetOperation(c81180170.op1)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c81180170.cn1)
	c:RegisterEffect(e3)
	
	--샐비지
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81180170)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81180170.tg2)
	e2:SetOperation(c81180170.op2)
	c:RegisterEffect(e2)
	
	--레벨
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_LEVEL)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetValue(-1)
	c:RegisterEffect(e4)
end

--덤핑
function c81180170.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81180170.filter0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcb5) and not c:IsCode(81180170)
end
function c81180170.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81180170.filter0,tp,LOCATION_DECK,0,1,nil)
		and e:GetHandler():GetLevel()>1
	end
	Duel.SetOperationInfo(0,CATEGORY_TO_GRAVE,nil,1,tp,LOCATION_DECK)
end
function c81180170.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81180170.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		if c:GetLevel()>1 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(-1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end

--샐비지
function c81180170.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb5) and c:IsType(TYPE_MONSTER) and not c:IsCode(81180170)
end
function c81180170.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c81180170.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81180170.filter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81180170.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81180170.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end


