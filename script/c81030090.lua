--hyotan: kyou

function c81030090.initial_effect(c)

	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)

	--ATK / DEF update
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e2:SetValue(200)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81030090,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,81030090)
	e4:SetCost(c81030090.thco)
	e4:SetTarget(c81030090.thtg)
	e4:SetOperation(c81030090.thop)
	c:RegisterEffect(e4)

	--replace
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81030090,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,81030091)
	e5:SetCondition(aux.exccon)
	e5:SetCost(c81030090.rpco)
	e5:SetTarget(c81030090.rptg)
	e5:SetOperation(c81030090.rpop)
	c:RegisterEffect(e5)
	
end

--search
function c81030090.thcofilter(c)
	return c:IsDestructable() and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81030090.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return 
				Duel.IsExistingMatchingCard(c81030090.thcofilter,tp,LOCATION_SZONE,0,1,c)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c81030090.thcofilter,tp,LOCATION_SZONE,0,1,1,c)
	Duel.Destroy(g,REASON_COST)
end

function c81030090.thtgfilter(c)
	return c:IsSetCard(0xca3)
		and c:IsAbleToHand() and not c:IsCode(81030090)
end
function c81030090.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81030090.thtgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81030090.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81030090.thtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--replace
function c81030090.rpco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c81030090.rptgfilter(c)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER)
end
function c81030090.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81030090.rptgfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOFIELD,nil,1,tp,LOCATION_GRAVE)
end

function c81030090.rpop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81030090.rptgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
