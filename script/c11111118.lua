--μ(마이크로) 스타
local m=11111118
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,m)<1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1f5))
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	Duel.RegisterEffect(e2,tp)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Draw(tp,1,REASON_EFFECT)
end