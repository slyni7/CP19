--AA(아트엔젤) 에어 위저드
function c76859635.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,76859635)
	e1:SetTarget(c76859635.tg1)
	e1:SetOperation(c76859635.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c76859635.con2)
	e2:SetOperation(c76859635.op2)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e5:SetOperation(c76859635.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(76859635)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCountLimit(1,76859636)
	e6:SetTarget(c76859635.tg6)
	e6:SetOperation(c76859635.op6)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_XYZ_LEVEL)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(c76859635.val7)
	c:RegisterEffect(e7)
end
function c76859635.tfil1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_EARTH) and c:IsRace(RACE_FAIRY) and not c:IsCode(76859635)
end
function c76859635.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if chk==0 then
		return ((Duel.GetLocationCountFromEx and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)))
			or (not Duel.GetLocationCountFromEx and Duel.CheckLocation(tp,LOCATION_SZONE,13-seq)))
			and Duel.IsExistingMatchingCard(c76859631.tfil1,tp,LOCATION_DECK,0,1,nil)
	end
end
function c76859635.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local seq=c:GetSequence()
	if not (Duel.GetLocationCountFromEx and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)))
		or (not Duel.GetLocationCountFromEx and Duel.CheckLocation(tp,LOCATION_SZONE,13-seq)) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c76859635.tfil1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c76859635.con2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_SYNCHRO+REASON_XYZ)>0
end
function c76859635.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(76859635,0))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c76859635.val2)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
end
function c76859635.val2(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c76859635.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseSingleEvent(c,76859635,e,0,0,0,0)
end
function c76859635.tfil6(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsCode(76859611) or c:IsCode(76859621))
end
function c76859635.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859635.tfil6,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859635.op6(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c76859635.tfil6,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c76859635.val7(e,c,rc)
	local lv=c:GetLevel()
	local tp=c:GetControler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	return lv*0x10001+ct
end