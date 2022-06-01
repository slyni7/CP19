--H. Enchantment: Terra Gloria
function c99970032.initial_effect(c)

	--오버레이
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetType(EFFECT_TYPE_ACTIVATE)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetTarget(c99970032.target)
	e8:SetOperation(c99970032.activate)
	c:RegisterEffect(e8)
	
	--효과 부여
	local ex=Effect.CreateEffect(c)
	ex:SetDescription(aux.Stringid(99970032,1))
	ex:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	ex:SetType(EFFECT_TYPE_XMATERIAL)
	ex:SetCode(EFFECT_ADD_ATTRIBUTE)
	ex:SetValue(ATTRIBUTE_WATER+ATTRIBUTE_EARTH)
	ex:SetCondition(c99970032.discon2)
	c:RegisterEffect(ex)
	local ey=Effect.CreateEffect(c)
	ey:SetDescription(aux.Stringid(99970032,0))
	ey:SetCategory(CATEGORY_ATKCHANGE)
	ey:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_XMATERIAL)
	ey:SetCode(EVENT_FREE_CHAIN)
	ey:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	ey:SetHintTiming(TIMING_DAMAGE_STEP)
	ey:SetCountLimit(1)
	ey:SetCondition(c99970032.discon)
	ey:SetOperation(c99970032.atkop)
	ey:SetCost(c99970032.cost)
	c:RegisterEffect(ey)
	
	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99970032)
	e1:SetCondition(c99970032.thcon)
	e1:SetCost(c99970032.drcost)
	e1:SetTarget(c99970032.drtg)
	e1:SetOperation(c99970032.drop)
	c:RegisterEffect(e1)
	
end

--오버레이
function c99970032.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32)
end
function c99970032.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c99970032.filter(chkc) end
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingTarget(c99970032.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c99970032.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c99970032.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

--효과 부여
function c99970032.costfilter(c)
	return (c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER)) or c:IsSetCard(0xd33) and c:IsAbleToGraveAsCost()
end
function c99970032.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970032.costfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99970032.costfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99970032.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return c:IsSetCard(0xd32) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and (ph~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c99970032.discon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xd32)
end
function c99970032.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32)
end
function c99970032.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99970032.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end

--드로우
function c99970032.cfilter(c)
	return c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c99970032.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970032.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99970032.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c99970032.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xd32)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c99970032.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99970032.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
