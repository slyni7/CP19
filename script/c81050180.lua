--지저의 공포

function c81050180.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81050180)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c81050180.fltg)
	e1:SetOperation(c81050180.flop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81050180,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81050181)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c81050180.tg)
	e2:SetOperation(c81050180.op)
	c:RegisterEffect(e2)
end

--flip
function c81050180.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			end
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end

function c81050180.flopfilter(c)
	return c:IsFacedown() and ( c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER) )
end
function c81050180.flop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 then
		local tg=Duel.GetMatchingGroup(c81050180.flopfilter,tp,LOCATION_MZONE,0,nil)
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81050180,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local sg=tg:Select(tp,1,5,nil)
			Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
		end
	end
end

--recover
function c81050180.filter(c)
	return c:IsFaceup() and c:IsAbleToDeck() and c:IsSetCard(0xca6)
end
function c81050180.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81050180.filter(chkc)
	end
	if chk==0 then
		return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingTarget(c81050180.filter,tp,LOCATION_REMOVED,0,3,nil)
		and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81050180.filter,tp,LOCATION_REMOVED,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81050180.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or not c:IsRelateToEffect(e) or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then
		return
	end
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)~=0 and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 then
		local g=Duel.GetOperatedGroup()
		local ct=tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==3 then
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
