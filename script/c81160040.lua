--그림자무리의 혼백
function c81160040.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,c81160040.mfilter,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DARK),1,1)
	
	--Salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81160040,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81160040)
	e1:SetCondition(c81160040.cn)
	e1:SetTarget(c81160040.tg)
	e1:SetOperation(c81160040.op)
	c:RegisterEffect(e1)
	
	--Effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81160040,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81160041)
	e2:SetCondition(c81160040.ecn)
	e2:SetTarget(c81160040.etg)
	e2:SetOperation(c81160040.eop)
	c:RegisterEffect(e2)
	
	--spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81160040.vcn)
	e3:SetTarget(c81160040.vtg)
	e3:SetTargetRange(1,1)
	c:RegisterEffect(e3)
	
end

--material
function c81160040.mfilter(c)
	return c:IsCode(81160000)
end

--Salvage
function c81160040.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c81160040.filter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb3)
end
function c81160040.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c81160040.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81160040.filter1,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81160040.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81160040.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--effect
function c81160040.ecn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c81160040.filter2(c)
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcb3)
end
function c81160040.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81160040.filter2,tp,loc,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function c81160040.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81160040.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end

--limit
function c81160040.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0xcb3) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81160040.vcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81160040.filter3,tp,LOCATION_SZONE,0,1,nil)
end
function c81160040.vtg(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_REMOVED+LOCATION_GRAVE)
end
