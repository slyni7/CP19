--티아라 레인보우
function c17280012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,17280012+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17280012.tg1)
	e1:SetOperation(c17280012.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,17280013)
	e2:SetCondition(c17280012.con2)
	e2:SetCost(c17280012.cost2)
	e2:SetTarget(c17280012.tg2)
	e2:SetOperation(c17280012.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c17280012.tfilter11(c,e,tp)
	return c:IsSetCard(0x2c4) and c:IsType(TYPE_TUNER) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c17280012.tfilter12(c,e,tp)
	return c:IsSetCard(0x2c4) and (not c:IsType(TYPE_TUNER)) and c:IsType(TYPE_MONSTER)
		and (c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c17280012.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17280012.tfilter11,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(c17280012.tfilter12,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
end
function c17280012.op1(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c17280012.tfilter11,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c17280012.tfilter12,tp,LOCATION_DECK,0,nil,e,tp)
	if g1:GetCount()<1 or g2:GetCount()<1 then
		return
	end
	Duel.Hint(HINT_SELECMTSG,tp,HINTMSG_CONFIRM)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECMTSG,tp,HINTMSG_CONFIRM)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	Duel.ConfirmCards(1-tp,sg1)
	Duel.ShuffleDeck(tp)
	local cg=sg1:Select(1-tp,1,1,nil)
	local tc=cg:GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	if not tc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(17280012,0)) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	else
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
	sg1:RemoveCard(tc)
	Duel.SendtoGrave(sg1,REASON_EFFECT)
end
function c17280012.nfilter2(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x2c4)
end
function c17280012.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c17280012.nfilter2,1,nil,tp)
end
function c17280012.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c17280012.tfilter2(c,e)
	return c:IsAbleToDeck() and c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end
function c17280012.tfunction2(c)
	if c:IsSetCard(0x2c4) then
		return c:GetAttribute()*0x10001+0x1000
	else
		return c:GetAttribute()
	end
end
function c17280012.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local g=Duel.GetMatchingGroup(c17280012.tfilter2,tp,LOCATION_GRAVE,0,nil,e)
	if chk==0 then
		return g:CheckWithSumEqual(c17280012.tfunction2,0x103f,6,6) and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectWithSumEqual(tp,c17280012.tfunction2,0x103f,6,6)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,6,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c17280012.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end