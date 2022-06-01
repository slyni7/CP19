function c81120040.initial_effect(c)
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c81120040.ocn)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81120040+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81120040.cn)
	e1:SetTarget(c81120040.tg)
	e1:SetOperation(c81120040.op)
	c:RegisterEffect(e1)
	--standard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81120040,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,81120041)
	e2:SetTarget(c81120040.vtg)
	e2:SetOperation(c81120040.vop)
	c:RegisterEffect(e2)
end

--act
function c81120040.filter(c)
	return c:IsAttribute(0x20) and c:IsFaceup() and c:IsCode(81120000) 
end
function c81120040.ocn(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81120040.filter,tp,LOCATION_MZONE,0,nil)>0
end

function c81120040.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcaf)
end
function c81120040.cn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81120030.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c81120040.filter2(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c81120040.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81120040.filter2,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c81120040.filter2,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	if Duel.IsExistingMatchingCard(c81120040.filter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetChainLimit(c81120040.lim)
	end
end
function c81120040.lim(e,ep,tp)
	return tp==ep
end
function c81120040.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81120040.filter2,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	Duel.BreakEffect()
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	Duel.SetLP(tp,Duel.GetLP(tp)-ct*400)
end

--standard
function c81120040.filter3(c)
	return not c:IsSetCard(0x2caf) and c:IsSetCard(0xcaf) and c:IsAbleToHand()
end
function c81120040.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE+LOCATION_DECK
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c81120040.filter3,tp,loc,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,loc)
end
function c81120040.vop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=LOCATION_GRAVE+LOCATION_DECK
	if not c:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then
		local g=Duel.SelectMatchingCard(tp,c81120040.filter3,tp,loc,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			Duel.ShuffleDeck(tp)
		end
	end
end
