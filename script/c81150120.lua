--멜로디블 노트-볼란테
function c81150120.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81150120,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(81150120,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,81150120)
	e2:SetTarget(c81150120.tg)
	e2:SetOperation(c81150120.op)
	c:RegisterEffect(e2)
	
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81150120,3))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,81150121)
	e5:SetCondition(c81150120.vcn)
	e5:SetCost(c81150120.vco)
	e5:SetTarget(c81150120.vtg)
	e5:SetOperation(c81150120.vop)
	c:RegisterEffect(e5)
end

--salvage
function c81150120.filter1(c)
	return c:IsSSetable(true) and c:IsSetCard(0xcb2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	and c:IsFaceup() 	and not c:IsCode(81150120)
end
function c81150120.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c81150120.filter1(chkc) 
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81150120.filter1,tp,LOCATION_REMOVED,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81150120.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c81150120.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_DECK)
		tc:RegisterEffect(e1,true)
	end
end

--search
function c81150120.vcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) 
	and rp~=tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp
end
function c81150120.filter3(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcb2)
end
function c81150120.vco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81150120.filter3,tp,LOCATION_GRAVE,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81150120.filter3,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81150120.filter4(c,tp)
	return not c:IsCode(81150120)
	and c:IsSetCard(0xcb2) and c:IsType(TYPE_SPELL+TYPE_TRAP)
	and ( c:IsAbleToHand() or ( c:IsSSetable(true) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 ) )
end
function c81150120.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81150120.filter4,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81150120.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81150120,3))
	local g=Duel.SelectMatchingCard(tp,c81150120.filter4,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsAbleToHand()
		local b2=tc:IsSSetable(true) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(81150120,4)) ) then
			Duel.SSet(tp,tc)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
