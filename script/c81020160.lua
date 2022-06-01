function c81020160.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81020160+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81020160.sttg)
	e1:SetOperation(c81020160.stop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c81020160.rttg)
	e2:SetOperation(c81020160.rtop)
	c:RegisterEffect(e2)
	
end

--set
function c81020160.sttgfilter(c)
	return c:IsSSetable(true) and c:IsSetCard(0xca2) and c:IsType(TYPE_SPELL) and not c:IsCode(81020160)
end
function c81020160.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local count=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_FUSION)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81020160.sttgfilter,tp,LOCATION_DECK,0,1,nil,tp)
	end
	if count>0 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end

function c81020160.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81020160.sttgfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		if Duel.IsPlayerCanDraw(tp,1)
			and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_FUSION)>0
			and Duel.SelectYesNo(tp,aux.Stringid(81020160,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

--return
function c81020160.rttgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca2) and c:IsAbleToHand()
end
function c81020160.rttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81020160.rttgfilter(chkc)
	end
	if chk==0 then
		return e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingTarget(c81020160.rttgfilter,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectTarget(tp,c81020160.rttgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function c81020160.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
