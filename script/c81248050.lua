--THE CELL - 더블링
function c81248050.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,81248050)
	e1:SetTarget(c81248050.tar1)
	e1:SetOperation(c81248050.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_DISABLE)
	e2:SetCountLimit(1,81248051)
	e2:SetTarget(c81248050.tar2)
	e2:SetOperation(c81248050.op2)
	c:RegisterEffect(e2)
end
function c81248050.tfil11(c,tp)
	return c:IsFaceup() and c:IsAbleToHand() and Duel.GetMZoneCount(tp,c,tp)>0
end
function c81248050.tfil12(c,e,tp)
	return c:IsSetCard(0xc84) and c:IsType(TYPE_PENDULUM)
end
function c81248050.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsOnField() and c81248050.tfil11(chkc,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81248050.tfil11,tp,LOCATION_ONFIELD,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(c81248050.tfil12,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81248050.tfil11,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81248050.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c81248050.tfil12,tp,0x01,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c81248050.tfil2(c)
	return c:IsFaceup() and (c:IsAbleToGrave() or aux.disfilter1(c))
end
function c81248050.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_PZONE,0,nil)
	if chk==0 then
		return c:IsAbleToDeck() and #g>0 and Duel.IsExistingMatchingCard(c81248050.tfil2,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function c81248050.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_PZONE,0,nil)
	if #g<1 then
		return
	end
	local ct=Duel.SendtoHand(g,nil,REASON_EFFECT)
	if ct<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c81248050.tfil2,tp,0,LOCATION_ONFIELD,1,ct,nil)
	if #sg<1 then
		return
	end
	local tc=sg:GetFirst()
	local gg=Group.CreateGroup()
	local ng=Group.CreateGroup()
	while tc do
		if tc:IsAbleToGrave() and (not aux.disfilter1(tc) or Duel.SelectOption(tp,aux.Stringid(81248050,1),aux.Stringid(81248050,2))==0) then
			gg:AddCard(tc)
		else
			ng:AddCard(tc)
		end
		tc=sg:GetNext()
	end
	if #gg>0 then
		Duel.SendtoGrave(gg,REASON_EFFECT)
	end
	if #ng>0 then
		local nc=ng:GetFirst()
		while nc do
			Duel.NegateRelatedChain(nc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			nc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			nc:RegisterEffect(e2)
			nc=ng:GetNext()
		end
	end
	if c:IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end