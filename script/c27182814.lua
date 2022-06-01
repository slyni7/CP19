--스크립트의 날개 위에
function c27182814.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c27182814.tg1)
	e1:SetOperation(c27182814.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c27182814.val2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c27182814.con4)
	e4:SetTarget(c27182814.tg4)
	e4:SetOperation(c27182814.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetCountLimit(1,27182814)
	e5:SetCost(c27182814.cost5)
	e5:SetTarget(c27182814.tg5)
	e5:SetOperation(c27182814.op5)
	c:RegisterEffect(e5)
end
function c27182814.tfilter1(c)
	return c:IsSetCard(0x2c2) and c:IsFaceup()
end
function c27182814.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c27182814.tfilter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182814.tfilter1,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c27182814.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function c27182814.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e)
		and tc:IsRelateToEffect(e)
		and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c27182814.val2(e,c)
	return c:IsSetCard(0x2c2)
end
function c27182814.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	return ec
		and eg:IsContains(ec)
		and ep~=tp
end
function c27182814.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,ev)
end
function c27182814.op4(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c27182814.cfilter5(c)
	return c:IsSetCard(0x2c2) and c:IsAbleToDeckAsCost()
end
function c27182814.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27182814.cfilter5,tp,LOCATION_GRAVE,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c27182814.cfilter5,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c27182814.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c27182814.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end