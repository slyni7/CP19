--율자의 심연
function c81220050.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcbb))
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	--deckdes
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81220050,0))
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,81220050)
	e4:SetTarget(c81220050.tg4)
	e4:SetOperation(c81220050.op4)
	c:RegisterEffect(e4)
	
	--salvage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81220050,1))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(c81220050.tg5)
	e5:SetOperation(c81220050.op5)
	c:RegisterEffect(e5)
end

--deckdes
function c81220050.filter0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcbb)
end
function c81220050.filter1(c)
	return c:IsSSetable() and c:IsSetCard(0xcbb) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81220050.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c81220050.filter0,tp,LOCATION_DECK,0,nil)
		return g:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,1,tp,LOCATION_DECK)
end
function c81220050.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetMatchingGroup(c81220050.filter0,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)<3 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg2=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg2:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tg3=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	tg1:Merge(tg3)
	if tg1:GetCount()==3 then
		Duel.ConfirmCards(1-tp,tg1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=tg1:Select(1-tp,1,1,nil)
		local cg=sg:GetFirst()
		if cg:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.SSet(tp,cg)
			tg1:RemoveCard(cg)
		end
		Duel.SendtoGrave(tg1,REASON_EFFECT)	
	end
end

--salvage
function c81220050.filter2(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xcbb)
end
function c81220050.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c81220050.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c81220050.filter2,tp,LOCATION_GRAVE,0,3,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81220050.filter2,tp,LOCATION_GRAVE,0,3,3,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81220050.op5(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then
		return
	end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then 
		Duel.ShuffleDeck(tp) 
	end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end