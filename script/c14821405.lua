--화사한 히다마리장
function c14821405.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,14821405)
	e1:SetCondition(c14821405.spcon)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,148214051)
	e2:SetCondition(c14821405.condition)
	e2:SetTarget(c14821405.settg)
	e2:SetOperation(c14821405.setop)
	c:RegisterEffect(e2)
end
function c14821405.spfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
end
function c14821405.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c14821405.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c14821405.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO 
end
function c14821405.setfilter(c)
	return (c:IsCode(80280737) or c:IsCode(88332693)) and c:IsSSetable()
end
function c14821405.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14821405.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c14821405.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c14821405.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		tc:RegisterEffect(e2)
	end
end