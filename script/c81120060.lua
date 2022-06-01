function c81120060.initial_effect(c)

	c:SetUniqueOnField(1,0,81120060)	
	--upper
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(c81120060.filter))
	e1:SetValue(c81120060.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(0x20)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetValue(3000)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e4)
	
	--replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c81120060.etg)
	c:RegisterEffect(e5)
	
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(81120060,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_LEAVE_TO_FIELD)
	e6:SetCountLimit(1,81120060)
	e6:SetCondition(c81120060.vcn)
	e6:SetTarget(c81120060.vtg)
	e6:SetOperation(c81120060.vop)
	c:RegisterEffect(e6)
end

--immune
function c81120060.val(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c81120060.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcaf) and c:IsType(TYPE_MONSTER)
end

--replace
function c81120060.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ex=c:GetDestination()
	if chk==0 then
		return c:IsOnField() and c:IsFaceup()
		and
			(  ex==LOCATION_REMOVED
			or ex==LOCATION_GRAVE
			or ex==LOCATION_HAND
			or ex==LOCATION_DECK
			)
		and Duel.IsExistingMatchingCard(c81120060.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(81120060,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c81120060.filter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	return true
		else return false
	end
end

--tohand
function c81120060.vcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
end
function c81120060.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c81120060.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
