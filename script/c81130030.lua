function c81130030.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81130030,2))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81130030)
	e1:SetCondition(c81130030.cn)
	e1:SetCost(c81130030.co)
	e1:SetTarget(c81130030.tg)
	e1:SetOperation(c81130030.op)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81130030,3))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,81130031)
	e2:SetTarget(c81130030.etg)
	e2:SetOperation(c81130030.eop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

--effect
function c81130030.mfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0xcb0)
end
function c81130030.cn(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c81130030.mfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c81130030.co(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(81130030,tp,ACTIVITY_SPSUMMON)==0
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81130030.lim)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterEffect(e1,tp)
end
function c81130030.lim(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsSetCard(0xcb0)
end

function c81130030.filter(c,tp)
	return not c:IsForbidden() and not c:IsFaceup() and c:IsSetCard(0xcb0) and c:IsType(TYPE_CONTINUOUS) and c:CheckUniqueOnField(tp)
	and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_SZONE,0,1,nil,c:GetCode())
end
function c81130030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81130030.filter,tp,LOCATION_DECK,0,1,nil,tp)
	end
end
function c81130030.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c81130030.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	and c:IsLocation(LOCATION_HAND) and ( c:IsSummonableCard() or c:IsAbleToGrave() ) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(c81130030.vcn)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if c:IsSummonable(true,nil) and c:IsAbleToGrave() then
			op=Duel.SelectOption(tp,aux.Stringid(81130030,0),aux.Stringid(81130030,1))
		elseif c:IsAbleToGrave() then
			op=Duel.SelectOption(tp,aux.Stringid(81130030,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(81130030,1))
		end
		e:SetLabel(op)
		if op==0 then
			Duel.Summon(tp,c,true,nil)
		else
			Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
		end
	end
end
function c81130030.vcn(e,c,minc)
	if c==nil then
		return true
	end
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

--indes
function c81130030.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xcb0)
end
function c81130030.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and c81130030.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81130030.filter2,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81130030.filter2,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
end
function c81130030.eop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetValue(c81130030.dfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
	end
end
function c81130030.dfilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
