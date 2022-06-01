--H. Enchanter: 6
function c99970026.initial_effect(c)

	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd32),2,2)
	c:EnableReviveLimit()
	
	--특수 소환
	local ex=Effect.CreateEffect(c)
	ex:SetDescription(aux.Stringid(99970026,0))
	ex:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ex:SetType(EFFECT_TYPE_QUICK_O)
	ex:SetCode(EVENT_CHAINING)
	ex:SetRange(LOCATION_MZONE)
	ex:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	ex:SetCountLimit(1,99970026)
	ex:SetCondition(c99970026.spcon)
	ex:SetTarget(c99970026.sptg)
	ex:SetOperation(c99970026.spop)
	c:RegisterEffect(ex)
	
	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970026,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c99970026.drtg)
	e1:SetOperation(c99970026.drop)
	e1:SetCost(c99970026.drcost)
	c:RegisterEffect(e1,false,1)

	--내성 부여
	local e3=Effect.CreateEffect(c)
	ex:SetDescription(aux.Stringid(99970026,2))
	ex:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(c99970026.condition)
	e3:SetTarget(c99970026.reptg)
	c:RegisterEffect(e3)
	
end

--특수 소환
function c99970026.cfilter(c,g)
	return g:IsContains(c)
end
function c99970026.spcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c99970026.cfilter,1,nil,lg)
end
function c99970026.spfilter(c,e,tp)
	return c:IsSetCard(0xd32) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99970026.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99970026.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99970026.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--드로우
function c99970026.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c99970026.tdfilter(c)
	return c:IsSetCard(0xd33) and c:IsAbleToDeck()
end
function c99970026.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and chkc:IsControler(tp) and c99970026.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c99970026.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c99970026.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99970026.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()<=0 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

--내성 부여
function c99970026.condition(e)
	return e:GetHandler():IsSetCard(0xd32)
end
function c99970026.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
