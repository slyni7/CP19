--그림자무리의 혼란
function c81160050.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,c81160050.mfilter,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DARK),1,1)
	
	--Salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81160050,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81160050)
	e1:SetCondition(c81160050.cn)
	e1:SetTarget(c81160050.tg)
	e1:SetOperation(c81160050.op)
	c:RegisterEffect(e1)
	
	--Effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81160050,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81160051)
	e2:SetCondition(c81160050.ecn)
	e2:SetTarget(c81160050.etg)
	e2:SetOperation(c81160050.eop)
	c:RegisterEffect(e2)
	
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81160050,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81160052)
	e3:SetCondition(c81160050.vcn)
	e3:SetTarget(c81160050.vtg)
	e3:SetOperation(c81160050.vop)
	c:RegisterEffect(e3)
end

--material
function c81160050.mfilter(c)
	return c:IsCode(81160000)
end

--Salvage
function c81160050.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c81160050.filter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb3)
end
function c81160050.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c81160050.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81160050.filter1,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81160050.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81160050.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--effect
function c81160050.ecn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c81160050.filter2(c)
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcb3)
end
function c81160050.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81160050.filter2,tp,loc,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function c81160050.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81160050.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end

--destroy
function c81160050.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0xcb3) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81160050.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c81160050.vcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81160050.filter3,tp,LOCATION_SZONE,0,1,nil)
	and eg:IsExists(c81160050.cfilter,1,nil,1-tp)
end
function c81160050.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c81160050.vop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end


