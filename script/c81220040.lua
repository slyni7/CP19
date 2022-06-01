--율자의 권능
function c81220040.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81220040.tg1)
	e1:SetOperation(c81220040.op1)
	c:RegisterEffect(e1)
	
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81220040,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81220040)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81220040.tg2)
	e2:SetOperation(c81220040.op2)
	c:RegisterEffect(e2)
end

--activation
function c81220040.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcbb)
end
function c81220040.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81220040.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81220040.filter1,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81220040.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetChainLimit(c81220040.lm1)
end
function c81220040.lm1(e,ep,tp)
	return tp==ep
end
function c81220040.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOwnerPlayer(tp)
		e1:SetValue(c81220040.filter0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c81220040.filter0(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

--draw
function c81220040.filter2(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xcbb)
end
function c81220040.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(c81220040.filter2,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c81220040.op2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,c81220040.filter2,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.ShuffleDeck(tp)
		Duel.Draw(p,ct+1,REASON_EFFECT)
	end
end


