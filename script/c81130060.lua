function c81130060.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81130060.co)
	e1:SetTarget(c81130060.tg)
	e1:SetOperation(c81130060.op)
	c:RegisterEffect(e1)
end

--activate
function c81130060.co(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler())
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c81130060.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb0) and c:IsAbleToHand() and not c:IsCode(81130060)
end
function c81130060.ofilter1(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsFaceup()
end
function c81130060.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c81130060.ofilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81130060.filter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81130060.filter,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81130060.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	local cat=CATEGORY_TOHAND
	if ct>0 then cat=cat+CATEGORY_REMOVE+CATEGORY_DRAW
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
	e:SetCategory(cat)
end
function c81130060.ofilter2(c)
	return c:IsSetCard(0xcb0) and c:IsAbleToRemove()
end
function c81130060.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		if not Duel.IsPlayerCanDraw(tp,1) then
			return
		end
		local ct=Duel.GetMatchingGroupCount(c81130060.ofilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local og1=Duel.GetMatchingGroup(c81130060.ofilter2,tp,LOCATION_GRAVE,0,1,nil)
		if ct>0 and og1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81130060,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local oc=og1:Select(tp,1,1,nil)
			Duel.Remove(oc,POS_FACEUP,REASON_EFFECT)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end


