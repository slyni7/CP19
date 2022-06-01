--파이널 히어로 크레이지 쓰리
function c17290013.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,17290013)
	e4:SetCost(c17290013.cost4)
	e4:SetTarget(c17290013.tg4)
	e4:SetOperation(c17290013.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetCountLimit(1,172900130)
	e5:SetTarget(c17290013.tg5)
	e5:SetOperation(c17290013.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c17290013.cost6)
	e6:SetOperation(c17290013.op6)
	c:RegisterEffect(e6)
end
function c17290013.mat_filter(c)
	return c:IsRace(RACE_FAIRY) or c:IsSetCard(0x8)
end
function c17290013.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c17290013.tfilter4(c)
	return ((c:IsSetCard(0x2c3) and c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER))
		or (c:IsSetCard(0x2c3) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL)))
		and c:IsAbleToHand() and not c:IsCode(17290013)
end
function c17290013.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c17290013.tfilter4(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c17290013.tfilter4,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c17290013.tfilter4,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c17290013.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c17290013.tfilter5(c)
	return c:IsSetCard(0x2c3) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c17290013.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17290013.tfilter5,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17290013.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17290013.tfilter5,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17290013.cfilter6(c)
	return c:IsSetCard(0x2c3) and c:IsSetCard(0x8) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_WIND+ATTRIBUTE_FIRE)
end
function c17290013.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,c17290013.cfilter6,1,nil)
	end
	local g=Duel.SelectReleaseGroup(tp,c17290013.cfilter6,1,1,nil)
	local ct=g:GetFirst()
	local att=ct:GetAttribute()
	e:SetLabel(att)
	Duel.Release(g,REASON_COST)
end
function c17290013.op6(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	local c=e:GetHandler()
	if bit.band(att,ATTRIBUTE_LIGHT)==ATTRIBUTE_LIGHT then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetValue(c17290013.val61)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1,tp)
	end
	if bit.band(att,ATTRIBUTE_WIND)==ATTRIBUTE_WIND then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(1,1)
		e2:SetValue(c17290013.val62)
		e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e2,tp)
	end
	if bit.band(att,ATTRIBUTE_FIRE)==ATTRIBUTE_FIRE then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(1,1)
		e3:SetValue(c17290013.val63)
		e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e3,tp)
	end
end
function c17290013.val61(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not rc:IsImmuneToEffect(e)
end
function c17290013.val62(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not rc:IsImmuneToEffect(e)
end
function c17290013.val63(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and not rc:IsImmuneToEffect(e)
end