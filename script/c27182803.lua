--½ºÅ©¸³Æ®_Äµ³´_¸®¹«ºê
function c27182803.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27182803.tg1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c27182803.con2)
	e2:SetOperation(c27182803.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c27182803.con3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_REMOVE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c27182803.op4)
	c:RegisterEffect(e4)
end
function c27182803.tg1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x2c2)
end
function c27182803.nfilter2(c)
	return c:IsCode(27182801)
end
function c27182803.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27182803.nfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and c:GetFlagEffect(27182803)==0
end
function c27182803.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c27182803.nfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_CARD,0,27182803)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		c:RegisterFlagEffect(27182803,RESET_EVENT+0x1fe0000,0,0)
		Duel.RaiseSingleEvent(tc,27182801,e,REASON_EFFECT,tp,tp,0)
		Duel.RaiseEvent(tc,27182801,e,REASON_EFFECT,tp,tp,0)
	end
end
function c27182803.con3(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c27182803.ofilter4(c,tp)
	return c:IsControler(tp)
end
function c27182803.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsExists(c27182803.ofilter4,1,nil,tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,1,0)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		c:RegisterEffect(e1)
	end
	if eg:IsExists(c27182803.ofilter4,1,nil,1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_REMOVE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetAbsoluteRange(tp,0,1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		c:RegisterEffect(e1)
	end
end