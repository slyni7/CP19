--그림자무리의 악재
function c81160070.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,c81160070.mfilter,aux.NonTuner(Card.IsAttribute,ATTRIBUTE_DARK),1)
	
	--Salvage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81160070,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81160070)
	e1:SetCondition(c81160070.cn)
	e1:SetTarget(c81160070.tg)
	e1:SetOperation(c81160070.op)
	c:RegisterEffect(e1)
	
	--Effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81160070,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81160071)
	e2:SetCondition(c81160070.ecn)
	e2:SetTarget(c81160070.etg)
	e2:SetOperation(c81160070.eop)
	c:RegisterEffect(e2)
	
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81160072)
	e3:SetCondition(c81160070.vcn)
	e3:SetTarget(c81160070.vtg)
	e3:SetOperation(c81160070.vop)
	c:RegisterEffect(e3)
end

--Salvage
function c81160070.cn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c81160070.filter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb3)
end
function c81160070.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c81160070.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81160070.filter1,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c81160070.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81160070.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--effect
function c81160070.ecn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c81160070.filter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcb3)
end
function c81160070.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81160070.filter2,tp,loc,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end
function c81160070.eop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81160070.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
	end
end	

--negate
function c81160070.filter3(c)
	return c:IsFaceup() and c:IsSetCard(0xcb3) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81160070.vcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81160070.filter3,tp,LOCATION_SZONE,0,1,nil)
	and re:GetHandler()~=e:GetHandler()
	and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c81160070.filter4(c)
	return c:IsSetCard(0xcb3) and c:IsAbleToGrave() and ( c:IsFaceup() or c:IsLocation(LOCATION_HAND) )
end
function c81160070.vtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81160070.filter4,tp,0x02+0x0c,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTORY,eg,1,0,0)
	end
end
function c81160070.vop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) and	Duel.Destroy(eg,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c81160070.filter4,tp,0x02+0x0c,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)
		end	
	end
end
