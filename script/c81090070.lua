--bogakyou

function c81090070.initial_effect(c)

	--act
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c81090070.attg)
	e1:SetOperation(c81090070.atop)
	c:RegisterEffect(e1)
	
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c81090070.mtco)
	e2:SetTarget(c81090070.mttg)
	e2:SetOperation(c81090070.mtop)
	c:RegisterEffect(e2)
	
end

--act
function c81090070.attgfilter(c)
	return c:IsSetCard(0xcac) and c:IsAbleToDeck()
end
function c81090070.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) 
		and chkc:IsControler(tp)
		and c81090070.attgfilter(chkc)
	end
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c81090070.attgfilter,tp,LOCATION_REMOVED,0,3,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81090070.attgfilter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c81090070.atop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then
		return
	end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

--material
function c81090070.mtco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c81090070.mttgfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xcac)
end
function c81090070.mttgfilter2(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER)
end
function c81090070.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return	chkc:IsControler(tp)
		and chkc:IsLocation(LOCATION_MZONE)
		and c81090070.mttgfilter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81090070.mttgfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c81090070.mttgfilter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81090070.mttgfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end

function c81090070.mtop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c81090070.mttgfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
