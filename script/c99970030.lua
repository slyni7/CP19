--H. Enchantment: Solar Gloria
function c99970030.initial_effect(c)

	--오버레이
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c99970030.target)
	e2:SetOperation(c99970030.activate)
	c:RegisterEffect(e2)
	
	--효과 부여
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_XMATERIAL)
	ex:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	ex:SetValue(1)
	ex:SetCondition(c99970030.discon)
	c:RegisterEffect(ex)
	local ey=ex:Clone()
	ey:SetCode(EFFECT_UPDATE_DEFENSE)
	ey:SetValue(c99970030.atkval)
	c:RegisterEffect(ey)
	local ez=ex:Clone()
	ez:SetCode(EFFECT_UPDATE_ATTACK)
	ez:SetValue(c99970030.atkval)
	c:RegisterEffect(ez)
	local e9=ex:Clone()
	e9:SetCode(EFFECT_ADD_ATTRIBUTE)
	e9:SetValue(ATTRIBUTE_LIGHT+ATTRIBUTE_FIRE)
	c:RegisterEffect(e9)
	
	--샐비지
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99970030)
	e1:SetCondition(c99970030.thcon)
	e1:SetTarget(c99970030.thtg)
	e1:SetOperation(c99970030.thop)
	c:RegisterEffect(e1)

end

--오버레이
function c99970030.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32)
end
function c99970030.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99970030.filter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(c99970030.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99970030.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970030.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

--효과 부여
function c99970030.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xd32)
end
function c99970030.filtera(c)
	return c:IsFaceup() and c:IsSetCard(0xd32)
end
function c99970030.atkval(e,c)
	return Duel.GetMatchingGroupCount(c99970030.filtera,c:GetControler(),LOCATION_MZONE,0,nil)*300
end

--샐비지
function c99970030.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xd32)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c99970030.thfilter(c)
	return c:IsSetCard(0xd33) and not c:IsCode(99970030) and c:IsAbleToHand()
end
function c99970030.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c99970030.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99970030.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c99970030.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c99970030.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
