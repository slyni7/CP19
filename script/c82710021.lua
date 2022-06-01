--아르카나 포스 XX-저지먼트
function c82710021.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c82710021.con1)
	e1:SetTarget(c82710021.tar1)
	e1:SetOperation(c82710021.op1)
	c:RegisterEffect(e1)
end
function c82710021.nfil1(c)
	return c:IsSetCard(0x5) and c:IsFaceup()
end
function c82710021.con1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c82710021.nfil1,tp,LOCATION_MZONE,0,1,nil) then
		return false
	end
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c82710021.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local rc=re:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c82710021.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+0x17a0000)
	e1:SetTarget(c82710021.otar11)
	e1:SetOperation(c82710021.oop11)
	c:RegisterEffect(e1)
end
function c82710021.otar11(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,82710021,0x5,0x21,3000,3000,8,RACE_FAIRY,ATTRIBUTE_LIGHT)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c82710021.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then
		return
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,82710021,0x5,0x21,3000,3000,8,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCategory(CATEGORY_COIN)
		e1:SetReset(RESET_EVENT+0xfe0000)
		e1:SetTarget(c82710021.ootar1)
		e1:SetOperation(c82710021.ooop1)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c82710021.ootar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c82710021.ooop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else
		res=Duel.TossCoin(tp,1)
	end
	c82710021.arcanareg(c,res)
end
function c82710021.arcanareg(c,coin)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(c82710021.acon1)
	e1:SetValue(c82710021.aval1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetCondition(c82710021.acon2)
	e2:SetCost(c82710021.acost2)
	e2:SetTarget(c82710021.atar2)
	e2:SetOperation(c82710021.aop2)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c82710021.acon1(e)
	local c=e:GetHandler()
	return c:GetFlagEffectLabel(36690018)==1
end
function c82710021.aval1(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c82710021.acon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffectLabel(36690018)~=0 or ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then
		return false
	end
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER))
end
function c82710021.acfil2(c,at)
	if c:IsSetCard(0x5) and c:IsAbleToGraveAsCost() then
		if at&0x1>0 then
			return c:IsLevel(5,6)
		elseif at&0x2>0 then
			return c:IsLevelAbove(7)
		elseif at&0x4>0 then
			return c:IsLevelBelow(4)
		end
	end
	return false
end
function c82710021.acost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=re:GetActiveType()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c82710021.acfil2,tp,LOCATION_DECK,0,1,nil,at)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c82710021.acfil2,tp,LOCATION_DECK,0,1,1,nil,at)
	Duel.SendtoGrave(g,REASON_COST)
end
function c82710021.atar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
end
function c82710021.aop2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end