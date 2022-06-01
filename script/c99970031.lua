--H. Enchantment: Lunar Gloria
function c99970031.initial_effect(c)

	--오버레이
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99970031.target)
	e1:SetOperation(c99970031.activate)
	c:RegisterEffect(e1)
	
	--효과 부여
	local ex=Effect.CreateEffect(c)
	ex:SetDescription(aux.Stringid(99970031,1))
	ex:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	ex:SetType(EFFECT_TYPE_XMATERIAL)
	ex:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	ex:SetValue(1)
	ex:SetCondition(c99970031.discon)
	c:RegisterEffect(ex)
	local ey=ex:Clone()
	ey:SetCode(EFFECT_UPDATE_DEFENSE)
	ey:SetValue(500)
	c:RegisterEffect(ey)
	local e9=ex:Clone()
	e9:SetCode(EFFECT_ADD_ATTRIBUTE)
	e9:SetValue(ATTRIBUTE_DARK+ATTRIBUTE_WIND)
	e9:SetCondition(c99970031.discon2)
	c:RegisterEffect(e9)

	--덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970031,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c99970031.cost)
	e2:SetTarget(c99970031.tg)
	e2:SetOperation(c99970031.op)
	e2:SetCondition(aux.exccon)
	c:RegisterEffect(e2)

end

--오버레이
function c99970031.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32)
end
function c99970031.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99970031.filter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(c99970031.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99970031.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970031.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

--효과 부여
function c99970031.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd33)
end
function c99970031.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xd32) and Duel.IsExistingMatchingCard(c99970031.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c99970031.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xd32)
end

--덤핑
function c99970031.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c99970031.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd32) and c:IsAbleToGrave()
end
function c99970031.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99970031.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99970031.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
