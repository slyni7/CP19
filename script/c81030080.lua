--hyotan: sasame

function c81030080.initial_effect(c)

	c:EnableReviveLimit()
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,0xca3),3,2)
	
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81030080,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c81030080.rmco)
	e1:SetTarget(c81030080.rmtg)
	e1:SetOperation(c81030080.rmop)
	c:RegisterEffect(e1)
	
	--return to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81030080,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(c81030080.rdcn)
	e3:SetTarget(c81030080.rdtg)
	e3:SetOperation(c81030080.rdop)
	c:RegisterEffect(e3)
	
end

--remove
function c81030080.rmcn1(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_SEASERPENT)
end
function c81030080.rmcn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsRace,1,nil,RACE_SEASERPENT)
end

function c81030080.rmcofilter(c)
	return c:IsDestructable() and c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81030080.rmco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST)
		and Duel.IsExistingMatchingCard(c81030080.rmcofilter,tp,LOCATION_SZONE,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c81030080.rmcofilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end

function c81030080.rmtgfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c81030080.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81030080.rmtgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c81030080.rmtgfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function c81030080.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81030080.rmtgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

--return to deck
function c81030080.rdcn(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end

function c81030080.rdtgfilter(c)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c81030080.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return 
				chkc:IsLocation(LOCATION_GRAVE) 
			and chkc:IsControler(tp)
			and c81030080.rdtgfilter(chkc)
			end
	if chk==0 then return
				Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingTarget(c81030080.rdtgfilter,tp,LOCATION_GRAVE,0,1,c)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81030080.rdtgfilter,tp,LOCATION_GRAVE,0,1,3,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c81030080.rdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
