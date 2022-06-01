--님프 메모리즈: 쥴리아
function c99970062.initial_effect(c)

	--님프 메모리즈 공통효과
	local en=Effect.CreateEffect(c)
	en:SetType(EFFECT_TYPE_SINGLE)
	en:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(en)
	local em=Effect.CreateEffect(c)
	em:SetType(EFFECT_TYPE_FIELD)
	em:SetCode(EFFECT_SPSUMMON_PROC)
	em:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	em:SetRange(LOCATION_HAND)
	em:SetCondition(c99970062.NMcon)
	em:SetOperation(c99970062.NMop)
	c:RegisterEffect(em)

	--회수 + 드로우
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970062,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c99970062.drtg)
	e1:SetOperation(c99970062.drop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)

	--덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970062,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c99970062.con)
	e2:SetOperation(c99970062.tgop)
	e2:SetTarget(c99970062.tgtg)
	c:RegisterEffect(e2)
	
end

--님프 메모리즈 공통 효과
function c99970062.NMfilter(c)
	return c:IsSetCard(0xd35) and c:IsDiscardable()
end
function c99970062.NMcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c99970062.NMfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c99970062.NMop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c99970062.NMfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end

--회수 + 드로우
function c99970062.tdfilter(c)
	return c:IsSetCard(0xd35) and c:IsAbleToDeck()
end
function c99970062.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c99970062.tdfilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c99970062.tdfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c99970062.tdfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c99970062.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
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

--덤핑
function c99970062.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c99970062.filter(c)
	return c:IsSetCard(0xd35) and c:IsAbleToGrave()
end
function c99970062.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970062.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99970062.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99970062.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
