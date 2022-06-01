--그림자무리의 절규
function c81160060.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,c81160060.mfilter,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DARK),1,1)
	
	--Salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81160060,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81160060)
	e1:SetCondition(c81160060.cn)
	e1:SetTarget(c81160060.tg)
	e1:SetOperation(c81160060.op)
	c:RegisterEffect(e1)
	
	--Effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81160060,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81160061)
	e2:SetCondition(c81160060.ecn)
	e2:SetTarget(c81160060.etg)
	e2:SetOperation(c81160060.eop)
	c:RegisterEffect(e2)
	
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81160060.vcn)
	e3:SetTargetRange(0,1)
	e3:SetValue(c81160060.val)
	c:RegisterEffect(e3)
end

--Salvage
function c81160060.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c81160060.filter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb3)
end
function c81160060.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c81160060.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81160060.filter1,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81160060.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81160060.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--effect
function c81160060.ecn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c81160060.filter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcb3)
end
function c81160060.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81160060.filter2,tp,loc,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function c81160060.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81160060.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end	

--limit
function c81160060.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0xcb3) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81160060.vcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81160060.filter3,tp,LOCATION_SZONE,0,1,nil)
	and ( Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler() )
end
function c81160060.val(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
