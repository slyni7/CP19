--은악의 호수
function c4160009.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	-- return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4160009,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,4160009)
	e2:SetCondition(c4160009.spcon)
	e2:SetTarget(c4160009.sptg)
	e2:SetOperation(c4160009.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4160009,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,4160001)
	e3:SetCost(c4160009.thcost)
	e3:SetTarget(c4160009.thtg)
	e3:SetOperation(c4160009.thop)
	c:RegisterEffect(e3)

end

function c4160009.spfilter(c,e,tp)
	return c:IsSetCard(0x4d6) and c:IsFaceup()
end


function c4160009.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4160009.spfilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
end	

function c4160009.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   local c=e:GetHandler()
   if chk==0 then return c:IsAbleToHand()
 end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function c4160009.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

function c4160009.thfilter(c)
	return c:IsSetCard(0x4d6) and c:IsAbleToHand()
end
function c4160009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c4160009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4160009.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c4160009.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c4160009.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


