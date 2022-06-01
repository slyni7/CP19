--HMS(로열 네이비) 런던
function c81200060.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c81200060.mat,nil,nil,aux.NonTuner(Card.IsSetCard,0xcb7),1,99)
	
	--salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81200050,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81200060)
	e1:SetCondition(c81200060.cn1)
	e1:SetTarget(c81200060.tg1)
	e1:SetOperation(c81200060.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81200060.cn2)
	c:RegisterEffect(e2)
	
	--bounce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81200050,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c81200060.co3)
	e3:SetTarget(c81200060.tg3)
	e3:SetOperation(c81200060.op3)
	c:RegisterEffect(e3)

end

--material
function c81200060.mat(c)
	return c:IsType(TYPE_TUNER) or c:IsCode(81200020)
end



--salvage
function c81200060.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c81200060.cfilter(c,tp)
	return c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c81200060.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81200060.cfilter,1,nil,1-tp)
end

function c81200060.filter1(c)
	return c:IsAbleToHand() and ( c:IsSetCard(0xcb7) or c:IsSetCard(0xcb8) )
end
function c81200060.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c81200060.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81200060.filter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81200060.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81200060.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

function c81200060.filter3(c)
	return c:IsAbleToHand() and ( c:IsSetCard(0xcb7) or c:IsSetCard(0xcb8) ) and not c:IsCode(81200060)
end
function c81200060.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and c81200060.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81200060.filter3,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81200060.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81200060.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--bounce
function c81200060.filter2(c)
	return c:IsDiscardable() and ( ( c:IsSetCard(0xcb7) and c:IsType(TYPE_MONSTER) ) or c:IsSetCard(0xcb8) )
end
function c81200060.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81200060.filter2,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,c81200060.filter2,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c81200060.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c81200060.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end


