--파이널 히어로 퍼포먼스
function c17290004.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_HAND)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetCountLimit(1,17290004)
	e6:SetCost(c17290004.cost6)
	e6:SetTarget(c17290004.tg6)
	e6:SetOperation(c17290004.op6)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetCategory(CATEGORY_RECOVER)
	e7:SetCountLimit(1,172900040)
	e7:SetCondition(c17290004.con7)
	e7:SetTarget(c17290004.tg7)
	e7:SetOperation(c17290004.op7)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c17290004.mat_filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) or c:IsSetCard(0x8)
end
function c17290004.val4(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c17290004.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c17290004.tfilter6(c)
	return c:IsSetCard(0x2c3) and c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand() and not c:IsCode(17290004)
end
function c17290004.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17290004.tfilter6,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17290004.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17290004.tfilter6,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17290004.con7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetCode()==EVENT_SPSUMMON_SUCCESS then
		return c:GetSummonType()==SUMMON_TYPE_RITUAL
	end
	return true
end
function c17290004.tg7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,3000)
end
function c17290004.op7(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,3000,REASON_EFFECT)
end