--웹 인사이트

function c81050170.initial_effect(c)

	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81050170+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81050170.shco)
	e1:SetTarget(c81050170.shtg)
	e1:SetOperation(c81050170.shop)
	c:RegisterEffect(e1)
	
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81050170,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81050170.estg)
	e2:SetOperation(c81050170.esop)
	c:RegisterEffect(e2)
	
end

--search
function c81050170.shcofilter(c)
	return c:IsAbleToGraveAsCost()
	   and ( c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER) )
end
function c81050170.shco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_HAND
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81050170.shcofilter,tp,loc,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81050170.shcofilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81050170.shtgfilter(c)
	return c:IsAbleToHand()
	   and ( c:IsSetCard(0xca6) and c:IsType(TYPE_SPELL+TYPE_TRAP) )
end
function c81050170.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81050170.shtgfilter,tp,LOCATION_DECK,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81050170.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81050170.shtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--extra summon
function c81050170.estgfilter(c)
	return c:IsSetCard(0xca6) and c:IsSummonable(true,nil)
end
function c81050170.estg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81050170.estgfilter,tp,LOCATION_HAND,0,1,nil)
			end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c81050170.esop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81050170.estgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
