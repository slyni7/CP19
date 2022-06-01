--퀸 엘리자베스의 지령
function c81200130.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,81200130+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81200130.cn1)
	e1:SetCost(c81200130.co1)
	e1:SetTarget(c81200130.tg1)
	e1:SetOperation(c81200130.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c81200130.cn2)
	c:RegisterEffect(e2)
	
	--shuffle
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81200130,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c81200130.co3)
	e3:SetTarget(c81200130.tg3)
	e3:SetOperation(c81200130.op3)
	c:RegisterEffect(e3)
end

--activation
function c81200130.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb8)
end
function c81200130.cn2(e)
	return Duel.IsExistingMatchingCard(c81200130.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c81200130.cfilter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsSetCard(0xcb7)
end
function c81200130.cn1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev)
	and Duel.IsExistingMatchingCard(c81200130.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c81200130.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	end
end
function c81200130.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c81200130.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81200130.filter1,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81200130.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81200130.filter1,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 and Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re)
	and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local sg=g:Select(tp,1,1,nil)
		local og=sg:GetFirst()
		while og do
			Duel.NegateRelatedChain(og,RESET_TURN_SET)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			og:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			og:RegisterEffect(e2)
			og=sg:GetNext()
		end
	end
end

--shuffle
function c81200130.filter2(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xcb7) and c:IsType(TYPE_MONSTER)
	and c:IsFaceup()
end
function c81200130.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,81200130)==0
	end
	Duel.RegisterFlagEffect(tp,81200130,RESET_CHAIN,0,1)
end
function c81200130.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and c81200130.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c81200130.filter2,tp,LOCATION_GRAVE,0,3,nil)
		and e:GetHandler():IsAbleToDeck()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81200130.filter2,tp,LOCATION_GRAVE,0,3,3,nil)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81200130.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not c:IsRelateToEffect(e) and ( not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 ) then
		return
	end
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp) 
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end	


