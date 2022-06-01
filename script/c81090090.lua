--Rak-ka

function c81090090.initial_effect(c)

	--spr
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetValue(0x10)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,81090090)
	e3:SetCondition(c81090090.nscn)
	e3:SetCost(c81090090.nsco)
	e3:SetTarget(c81090090.nstg)
	e3:SetOperation(c81090090.nsop)
	c:RegisterEffect(e3)
	
end

function c81090090.nscn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,81090090)==0
end

function c81090090.nsco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1000)
	end
	Duel.PayLPCost(tp,1000)
end

function c81090090.nstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanSummon(tp)
	end
end

function c81090090.nsop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcac))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,81090090,RESET_PHASE+PHASE_END,0,1)
end
