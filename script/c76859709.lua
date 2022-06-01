--틴즈 프로젝트 - 토모요
function c76859709.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCountLimit(1)
	e1:SetCost(c76859709.cost1)
	e1:SetOperation(c76859709.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,76859709)
	e2:SetCost(c76859709.cost2)
	c:RegisterEffect(e2)
end
function c76859709.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckReleaseGroupEx(tp,Card.IsSetCard,1,c,0x2c0)
	end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsSetCard,1,1,c,0x2c0)
	Duel.Release(g,REASON_COST)
end
function c76859709.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1400)
		c:RegisterEffect(e1)
	end
end
function c76859709.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroupEx(tp,Card.IsSetCard,1,nil,0x2c0) and Duel.GetCurrentChain()>0
	end
	local g=Duel.SelectReleaseGroupEx(tp,Card.IsSetCard,1,1,nil,0x2c0)
	Duel.Release(g,REASON_COST)
end