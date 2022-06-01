--틴즈 프로세스 - 니코
function c76859718.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,76859718)
	e1:SetCost(c76859718.cost1)
	e1:SetTarget(c76859718.tar1)
	e1:SetOperation(c76859718.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+76859718)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCondition(c76859718.con2)
	e2:SetCost(c76859718.cost2)
	e2:SetTarget(c76859718.tar2)
	e2:SetOperation(c76859718.op2)
	c:RegisterEffect(e2)
	if not c76859718.glo_chk then
		c76859718.glo_chk=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c76859718.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c76859718.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c76859718.tfil1(c)
	return c:IsSetCard(0x2c0) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function c76859718.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859718.tfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859718.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859718.tfil1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c76859718.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c76859718.cfil2(c)
	return c:IsSetCard(0x2c0) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c76859718.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859718.cfil2,tp,LOCATION_GRAVE,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c76859718.cfil2,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c76859718.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c76859718.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c76859718.gofil1(c,tp)
	local re=c:GetReasonEffect()
	return c:IsSetCard(0x2c0) and c:IsReason(REASON_COST) and not c:IsReason(REASON_RETURN) and re:IsActiveType(TYPE_MONSTER) and c:IsControler(tp)
end
function c76859718.gop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>3 then
		if eg:IsExists(c76859718.gofil1,1,nil,0) then
			Duel.RaiseEvent(eg,EVENT_CUSTOM+76859718,re,r,0,0,0)
		end
		if eg:IsExists(c76859718.gofil1,1,nil,1) then
			Duel.RaiseEvent(eg,EVENT_CUSTOM+76859718,re,r,1,1,0)
		end
	end
end