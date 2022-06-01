--H. Enchantment: Circulation
function c99970036.initial_effect(c)

	--발동
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_ACTIVATE)
	ex:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(ex)

	--특소+오버레이
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970036,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,99970036)
	e1:SetCost(c99970036.cost)
	e1:SetTarget(c99970036.target)
	e1:SetOperation(c99970036.activate)
	c:RegisterEffect(e1)
	
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c99970036.destg)
	e3:SetOperation(c99970036.desop)
	c:RegisterEffect(e3)
	
	--샐비지
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99970036,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c99970036.thcon)
	e4:SetTarget(c99970036.thtg)
	e4:SetOperation(c99970036.thop)
	c:RegisterEffect(e4)
	
end

--특소+오버레이
function c99970036.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c99970036.filter(c,e,tp)
	return c:IsSetCard(0xd32) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970036.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xd33)
end
function c99970036.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c99970036.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) 
		and Duel.IsExistingTarget(c99970036.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c99970036.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c99970036.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c99970036.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=e:GetLabelObject()
	sg:RemoveCard(tc)
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		if sg:GetCount()>0 then 
			Duel.Overlay(tc,sg)
		end
	end
end

--세트
function c99970036.costfilter(c)
	return c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c99970036.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970036.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c99970036.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c99970036.setfilter(c)
	return c:IsSetCard(0xd33) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(99970036) and c:IsSSetable()
end
function c99970036.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970036.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c99970036.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c99970036.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g)
		Duel.ConfirmCards(1-tp,g)
	end
end

--파괴
function c99970036.check(c,tp)
	return c:IsControler(tp) and c:GetOverlayCount()>=2 and c:IsSetCard(0xd32)
end
function c99970036.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil
		and (c99970036.check(Duel.GetAttacker(),tp) or c99970036.check(Duel.GetAttackTarget(),tp)) end
	if c99970036.check(Duel.GetAttacker(),tp) then
		Duel.SetTargetCard(Duel.GetAttackTarget())
	else
		Duel.SetTargetCard(Duel.GetAttacker())
	end
end
function c99970036.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--샐비지
function c99970036.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0xd32)
		and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c99970036.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970036.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c99970036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c99970036.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c99970036.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c99970036.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
