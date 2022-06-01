--하이랜드 베타
function c47460006.initial_effect(c)

	--reroll
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47460006,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,47460006+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c47460006.tgcon)
	e2:SetTarget(c47460006.tgtg)
	e2:SetOperation(c47460006.tgop)
	c:RegisterEffect(e2)

	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)

end

function c47460006.tgfilter(c)
	return c:IsAbleToGrave()
end
function c47460006.tgcon(e,tp,eg,ep,ev,re,r,rp)

	local ct=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetDecktopGroup(tp,ct)

	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function c47460006.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function c47460006.tgop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,1,63,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	Duel.ShuffleDeck(p)
	Duel.BreakEffect()
	Duel.Draw(p,1+g:GetCount(),REASON_EFFECT)
end
