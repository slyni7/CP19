function c81120030.initial_effect(c)
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81120030.ocn)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,81120030+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81120030.cn)
	e1:SetTarget(c81120030.tg)
	e1:SetOperation(c81120030.op)
	c:RegisterEffect(e1)
	--standard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81120030,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,81120021)
	e2:SetTarget(c81120030.vtg)
	e2:SetOperation(c81120030.vop)
	c:RegisterEffect(e2)
end

--act
function c81120030.filter2(c)
	return c:IsAttribute(0x20) and c:IsFaceup() and c:IsCode(81120010) 
end
function c81120030.ocn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81120030.filter2,tp,LOCATION_MZONE,0,nil)>0
end

function c81120030.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcaf)
end
function c81120030.cn(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainNegatable(ev)
	and ( re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE) )
	and Duel.IsExistingMatchingCard(c81120030.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81120030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81120030.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--standard
function c81120030.filter(c)
	return not c:IsSetCard(0x1caf) and c:IsSetCard(0xcaf) and c:IsAbleToHand()
end
function c81120030.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE+LOCATION_DECK
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c81120030.filter,tp,loc,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c81120030.vop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_GRAVE+LOCATION_DECK
	if not c:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,c81120030.filter,tp,loc,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
		end
	end
end
