--Angel Notes - ´Ù Ä«Æ÷
function c76859117.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetCountLimit(1,76859117+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c76859117.tg2)
	e2:SetOperation(c76859117.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetHintTiming(TIMING_END_PHASE)
	e3:SetCost(c76859117.cost3)
	e3:SetTarget(c76859117.tg3)
	e3:SetOperation(c76859117.op3)
	c:RegisterEffect(e3)
end
function c76859117.tfilter2(c)
	return c:IsSetCard(0x2c8) and c:IsFaceup()
end
function c76859117.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859117.tfilter2,tp,LOCATION_MZONE,0,1,nil)
	end
end
function c76859117.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c76859117.tfilter2,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(tc:GetAttack()*2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(tc:GetDefense()/2)
		tc:RegisterEffect(e2)
		if tc:GetFlagEffect(76859117)<1 then
			tc:RegisterFlagEffect(76859117,RESET_EVENT+0x1fe0000,0,0)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetCondition(c76859117.ocon23)
			e3:SetOperation(c76859117.oop23)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
function c76859117.ocon23(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c76859117.oop23(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function c76859117.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c76859117.tfilter3(c)
	return c:IsSynchroSummonable(nil) and c:IsSetCard(0x2c8)
end
function c76859117.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859117.tfilter3,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c76859117.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c76859117.tfilter3,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end