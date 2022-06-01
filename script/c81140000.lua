--QC Envy
function c81140000.initial_effect(c)

	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81140000,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(c81140000.co)
	e1:SetTarget(c81140000.tg)
	e1:SetOperation(c81140000.op)
	c:RegisterEffect(e1)
	
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81140000,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,81140000)
	e3:SetTarget(c81140000.vtg)
	e3:SetOperation(c81140000.vop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c81140000.vcn)
	c:RegisterEffect(e4)
end

--salvage
function c81140000.filter1(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xcb1) and (not c:IsRace(RACE_SPELLCASTER))
	and c:IsType(TYPE_MONSTER)
end
function c81140000.co(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81140000.filter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81140000.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81140000.filter2(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb1) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81140000.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81140000.filter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c81140000.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c81140000.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--search
function c81140000.vcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end

function c81140000.filter3(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb1)
	and ( c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) or ( c:IsCode(81140080) ) )
end
function c81140000.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81140000.filter3,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81140000.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81140000.filter3,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
