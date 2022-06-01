--스크립트_캔낫_액티베이트
function c27182804.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27182804.tg1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c27182804.con2)
	e2:SetOperation(c27182804.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c27182804.con3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c27182804.op4)
	c:RegisterEffect(e4)
end
function c27182804.tg1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x2c2)
end
function c27182804.nfilter2(c)
	return c:IsCode(27182801)
end
function c27182804.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27182804.nfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and c:GetFlagEffect(27182804)==0
end
function c27182804.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c27182804.nfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_CARD,0,27182804)
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
		c:RegisterFlagEffect(27182804,RESET_EVENT+0x1fe0000,0,0)
		Duel.RaiseSingleEvent(tc,27182801,e,REASON_EFFECT,tp,tp,0)
		Duel.RaiseEvent(tc,27182801,e,REASON_EFFECT,tp,tp,0)
	end
end
function c27182804.con3(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c27182804.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if rp==tp then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetAbsoluteRange(tp,1,0)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetLabelObject(re)
			if re:IsActiveType(TYPE_MONSTER) then
				e1:SetValue(c27182804.val41)
			elseif re:IsActiveType(TYPE_SPELL) then
				e1:SetValue(c27182804.val42)
			else
				e1:SetValue(c27182804.val43)
			end
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_NEGATED)
			e2:SetRange(LOCATION_MZONE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			e2:SetLabelObject(e1)
			e2:SetOperation(c27182804.op42)
			c:RegisterEffect(e2)
		end
	end
	if rp==1-tp then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetAbsoluteRange(tp,0,1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetLabelObject(re)
			if re:IsActiveType(TYPE_MONSTER) then
				e1:SetValue(c27182804.val41)
			elseif re:IsActiveType(TYPE_SPELL) then
				e1:SetValue(c27182804.val42)
			else
				e1:SetValue(c27182804.val43)
			end
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_NEGATED)
			e2:SetRange(LOCATION_MZONE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			e2:SetLabelObject(e1)
			e2:SetOperation(c27182804.op42)
			c:RegisterEffect(e2)
		end
	end
end
function c27182804.val41(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER)
		and not rc:IsImmuneToEffect(e)
end
function c27182804.val42(e,re,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_SPELL)
		and not rc:IsImmuneToEffect(e)
end
function c27182804.val43(e,re,rp)
	local rc=re:GetHandler()
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and re:IsActiveType(TYPE_TRAP)
		and not rc:IsImmuneToEffect(e)
end
function c27182804.op42(e,tp,eg,ep,ev,re,r,rp)
	local le=e:GetLabelObject()
	local lre=le:GetLabelObject()
	if re==lre then
		le:Reset()
	end
end