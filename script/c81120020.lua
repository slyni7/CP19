function c81120020.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c81120020.ocn)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,81120020+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81120020.cn)
	e1:SetCost(c81120020.co)
	e1:SetTarget(c81120020.tg)
	e1:SetOperation(c81120020.op)
	c:RegisterEffect(e1)
	if not AshBlossomTable then AshBlossomTable={} end
	--standard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81120020,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,81120021)
	e2:SetTarget(c81120020.vtg)
	e2:SetOperation(c81120020.vop)
	c:RegisterEffect(e2)
end

--act
function c81120020.filter(c)
	return c:IsAttribute(0x20) and c:IsFaceup() and c:IsCode(81120010) 
end
function c81120020.ocn(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81120020.filter,tp,LOCATION_MZONE,0,nil)>0
end

function c81120020.cn(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsDisabled() then
		return false
	end
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2=(Duel.GetOperationInfo(ev,CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_DRAW))
	local ex3=(Duel.GetOperationInfo(ev,CATEGORY_SEARCH) or re:IsHasCategory(CATEGORY_SEARCH))
	if not Duel.IsChainDisablable(ev) then
		return false
	end
	if ex1 or ex2 or ex3 then
		return true
	end
	for i,eff in ipairs(AshBlossomTable) do
		if eff==re then 
			return true
		end
	end
	return false
end
function c81120020.filter2(c)
	return c:IsReleasable() and c:IsSetCard(0xcaf)
end
function c81120020.co(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81120020.filter2,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81120020.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c81120020.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return not re:GetHandler():IsStatus(STATUS_DISABLED)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c81120020.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev)~=0 and Duel.SelectYesNo(tp,aux.Stringid(81120020,0)) then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end

--standard
function c81120020.filter3(c)
	return not c:IsSetCard(0x1caf) and c:IsSetCard(0xcaf) and c:IsAbleToHand()
end
function c81120020.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE+LOCATION_DECK
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c81120020.filter3,tp,loc,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c81120020.vop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_GRAVE+LOCATION_DECK
	if not c:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,c81120020.filter3,tp,loc,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
		end
	end
end
