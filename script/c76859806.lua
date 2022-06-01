--아더월드의 구원
function c76859806.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCountLimit(1,76859806)
	e1:SetCost(c76859806.cost1)
	e1:SetTarget(c76859806.tar1)
	e1:SetOperation(c76859806.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,76859807)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c76859806.tar2)
	e2:SetOperation(c76859806.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(76859806,ACTIVITY_SPSUMMON,c76859806.afil1)
end
function c76859806.afil1(c)
	return c:GetSummonLocation()~=LOCAITON_GRAVE
end
function c76859806.cfil1(c)
	return c:IsSetCard(0x2cb) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function c76859806.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(76859806,tp,ACTIVITY_SPSUMMON)<1
			and Duel.IsExistingMatchingCard(c76859806.cfil1,tp,LOCATION_GRAVE,0,1,nil)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76859806.tar11)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c76859806.cfil1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c76859806.tar11(e,c)
	return c:IsLocation(LOCATION_GRAVE)
end
function c76859806.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c76859806.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
end
function c76859806.tfil2(c)
	return c:IsSetCard(0x2cb) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function c76859806.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859806.tfil2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c76859806.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859806.tfil2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end