--Origin fiend "Claustrum"

function c81080100.initial_effect(c)

	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81080100,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,81080100)
	e1:SetTarget(c81080100.svtg)
	e1:SetOperation(c81080100.svop)
	c:RegisterEffect(e1)
	local e0=e1:Clone()
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c81080100.cn)
	c:RegisterEffect(e0)
	--salvage2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81080100,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c81080100.svco2)
	e2:SetTarget(c81080100.svtg2)
	e2:SetOperation(c81080100.svop2)
	c:RegisterEffect(e2)
	
	--CANNOT TRIGGER
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
	
end

--salvage
function c81080100.cn(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0xcab)
end
function c81080100.svtgfilter(c)
	return ( c:IsFaceup() and c:IsAbleToHand()
		and ( c:IsSetCard(0xcab) and c:IsType(TYPE_MONSTER) ) )
		and not c:IsCode(81080100)
end
function c81080100.svtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingTarget(c81080100.svtgfilter,tp,LOCATION_REMOVED,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81080100.svtgfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81080100.svop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--salvage2
function c81080100.svco2filter(c)
	return ( c:IsSetCard(0xcab) and c:IsAbleToRemoveAsCost() )
		and not c:IsCode(81080100)
end
function c81080100.svco2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81080100.svco2filter,tp,LOCATION_GRAVE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81080100.svco2filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81080100.svtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				e:GetHandler():IsAbleToHand()
			end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c81080100.svop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
