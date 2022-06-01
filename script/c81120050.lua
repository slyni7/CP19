function c81120050.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81120050.ocn)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81120050,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCountLimit(1,81120050+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81120050.cn1)
	e1:SetTarget(c81120050.tg1)
	e1:SetOperation(c81120050.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81120050,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,81120050+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c81120050.cn2)
	e2:SetTarget(c81120050.tg2)
	e2:SetOperation(c81120050.op2)
	c:RegisterEffect(e2)
	--standard
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81120050,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,81120041)
	e3:SetTarget(c81120050.vtg)
	e3:SetOperation(c81120050.vop)
	c:RegisterEffect(e3)
end

--act
function c81120050.filter(c)
	return c:IsAttribute(0x20) and c:IsFaceup() and c:IsCode(81120000) 
end
function c81120050.ocn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81120050.filter,tp,LOCATION_MZONE,0,nil)>0
end
--disable summon
function c81120050.filter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCode(81120000)
end
function c81120050.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
	and Duel.GetMatchingGroupCount(c81120050.filter2,tp,LOCATION_MZONE,0,nil)>0
end
function c81120050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c81120050.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateSummon(eg) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c81120050.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
	end
end
--negate effect
function c81120050.cn2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
	and Duel.GetMatchingGroupCount(c81120050.filter2,tp,LOCATION_MZONE,0,nil)>0
end
function c81120050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(e) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81120050.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c81120050.filter2,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
	end
end

--standard
function c81120050.filter3(c)
	return not c:IsSetCard(0x2caf) and c:IsSetCard(0xcaf) and c:IsAbleToHand()
end
function c81120050.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE+LOCATION_DECK
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c81120050.filter3,tp,loc,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c81120050.vop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_GRAVE+LOCATION_DECK
	if not c:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,c81120050.filter3,tp,loc,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
		end
	end
end
