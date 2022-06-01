--스크립트_유니크_온_필드
function c27182819.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c27182819.tg1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c27182819.con2)
	e2:SetOperation(c27182819.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c27182819.con3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c27182819.tg4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e5)
end
function c27182819.tg1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0x2c2)
end
function c27182819.nfilter2(c)
	return c:IsCode(27182801)
end
function c27182819.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c27182819.nfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and c:GetFlagEffect(27182819)==0
end
function c27182819.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c27182819.nfilter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true) then
		c:RegisterFlagEffect(27182819,RESET_EVENT+0x1fe0000,0,0)
		Duel.RaiseSingleEvent(tc,27182801,e,REASON_EFFECT,tp,tp,0)
		Duel.RaiseEvent(tc,27182801,e,REASON_EFFECT,tp,tp,0)
	end
end
function c27182819.con3(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c27182819.tfilter4(c,att)
	return c:IsFaceup() and bit.band(c:GetAttribute(),att)~=0
end
function c27182819.tg4(e,c,sp,stp,spos,tp)
	local att=c:GetAttribute()
	return Duel.IsExistingMatchingCard(c27182819.tfilter4,sp,LOCATION_MZONE,0,1,nil,att)
end