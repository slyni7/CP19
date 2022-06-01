--엔듀미온 버스트
--오리카 지원 릴레이: 461 → 약사
--카드군 번호: 0xe83
function c112500029.initial_effect(c)

	--타점 상승
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,112500029+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c112500029.co1)
	e1:SetTarget(c112500029.tg1)
	e1:SetOperation(c112500029.op1)
	c:RegisterEffect(e1)

	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112500029,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,112500030)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c112500029.tg2)
	e2:SetOperation(c112500029.op2)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(112500029,ACTIVITY_ATTACK,c112500029.cfilter)
end

--타점 상승
function c112500029.cfilter(c)
	return c:IsSetCard(0xe83)
end
function c112500029.filter1(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP)
end
function c112500029.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c112500029.filter1,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c112500029.filter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c112500029.efilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe83)
end
function c112500029.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
end
function c112500029.op1(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c112500029.efilter,tp,LOCATION_MZONE,0,nil)
	local sc=sg:GetFirst()
	while sc do
		local ct=sc:GetEquipCount()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*800)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e1)
		sc=sg:GetNext()
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTarget(c112500029.lim)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c112500029.lim(e,c)
	return not c:IsSetCard(0xe83)
end

--서치
function c112500029.filter0(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe83)
end
function c112500029.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c112500029.filter0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112500029.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112500029.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


