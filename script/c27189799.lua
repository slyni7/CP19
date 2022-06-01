--게테의 다원마도서
function c27189799.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27189799,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,27189799+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c27189799.con2)
	e2:SetCost(c27189799.cost2)
	e2:SetTarget(c27189799.tg2)
	e2:SetOperation(c27189799.op2)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27189799,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1c0+TIMING_BATTLE_PHASE)
	e3:SetCountLimit(1,27189799+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c27189799.con2)
	e3:SetCost(c27189799.cost2)
	e3:SetTarget(c27189799.tg3)
	e3:SetOperation(c27189799.op3)
	e3:SetLabel(2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(27189799,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e1)
	e4:SetCountLimit(1,27189799+EFFECT_COUNT_CODE_OATH)
	e4:SetCondition(c27189799.con2)
	e4:SetCost(c27189799.cost2)
	e4:SetTarget(c27189799.tg4)
	e4:SetOperation(c27189799.op4)
	e4:SetLabel(3)
	c:RegisterEffect(e4)
end
function c27189799.nfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c27189799.cfilter2(c)
	return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c27189799.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27189799.nfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c27189799.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27189799.cfilter2,tp,LOCATION_GRAVE,0,ct,nil)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c27189799.cfilter2,tp,LOCATION_GRAVE,0,ct,ct,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c27189799.tfilter2(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c27189799.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27189799.tfilter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler())
	end
	local g=Duel.GetMatchingGroup(c27189799.tfilter2,tp,LOCATION_SZONE,LOCATION_SZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27189799.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c27189799.tfilter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c27189799.tfilter3(c)
	return not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet()
end
function c27189799.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(c27189799.tfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c27189799.tfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c27189799.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c27189799.tfilter3,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		else
			local pos=Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
			Duel.ChangePosition(tc,pos)
		end
	end
end
function c27189799.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c27189799.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end