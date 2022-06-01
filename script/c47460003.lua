--하이랜드 알파
function c47460003.initial_effect(c)

	--tograve+copytodeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47460003,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,47460003+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c47460003.tgcon)
	e2:SetTarget(c47460003.tgtg)
	e2:SetOperation(c47460003.tgop)
	c:RegisterEffect(e2)

	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

end

function c47460003.tgfilter(c)
	return c:IsAbleToGrave()
end
function c47460003.tgcon(e,tp,eg,ep,ev,re,r,rp)

	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetDecktopGroup(tp,ct)

	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c47460003.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47460003.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47460003.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c47460003.tgfilter,tp,LOCATION_DECK,0,1,1,nil)

	if g:GetCount()>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT) then
			local co=g:GetFirst():GetCode()
			local token=Duel.CreateToken(tp,co)
			Duel.SendtoDeck(token,tp,0,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
		end
	end
end