--다원마도서고 크레센
function c27184023.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(27184023,ACTIVITY_CHAIN,c27184023.afilter)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,27184023+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c27184023.con2)
	e2:SetCost(c27184023.cost2)
	e2:SetTarget(c27184023.tg2)
	e2:SetOperation(c27184023.op2)
	c:RegisterEffect(e2)
end
function c27184023.afilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not rc:IsSetCard(0x206e))
end
function c27184023.nfilter2(c)
	return c:IsSetCard(0x206e) and c:IsType(TYPE_SPELL)
end
function c27184023.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c27184023.nfilter2,tp,LOCATION_GRAVE,0,1,nil)
end
function c27184023.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(27184023,tp,ACTIVITY_CHAIN)<1
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c27184023.val22)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c27184023.val22(e,re,tp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not rc:IsSetCard(0x206e)
end
function c27184023.tfilter2(c)
	return c:IsSetCard(0x206e) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c27184023.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c27184023.tfilter2,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c27184023.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c27184023.tfilter2,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:Select(tp,1,1,nil)
		local tc1=sg1:GetFirst()
		g:Remove(Card.IsCode,nil,tc1:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		local tc2=sg2:GetFirst()
		g:Remove(Card.IsCode,nil,tc2:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg1:Select(1-tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end