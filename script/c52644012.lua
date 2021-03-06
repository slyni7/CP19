--스타폴 스카이워커
function c52644012.initial_effect(c)
	--링크 소재 불가
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	--특수소환 + 파괴
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetCountLimit(1,152644012)
	e2:SetTarget(c52644012.sptg)
	e2:SetOperation(c52644012.spop)
	c:RegisterEffect(e2)
	--스탠바이에 암석족
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetTarget(c52644012.chtg)
	e3:SetOperation(c52644012.chop)
    c:RegisterEffect(e3)
	--암석족이면 파괴 X
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c52644012.indcon)
    e4:SetValue(1)
    c:RegisterEffect(e4)
	--화염족이면 패특소 -> 암석족
	local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,52644012)
	e5:SetCondition(c52644012.hspcon)
    e5:SetTarget(c52644012.hsptg)
    e5:SetOperation(c52644012.hspop)
    c:RegisterEffect(e5)
end
function c52644012.spfilter(c)
	return c:IsCode(52644009) and c:IsFaceup()
end
function c52644012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				or (Duel.IsExistingMatchingCard(c52644012.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
					and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0))
	end
	local dis=0
	if Duel.IsExistingMatchingCard(c52644012.spfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
	else
		dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	end
	e:SetLabel(dis)
	if dis<2^16 then
		local seq=math.log(dis,2)
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644012,seq))
	else
		local seq=math.log(dis,2)-16
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644003,seq))
	end
end
function c52644012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local dis=e:GetLabel()
	local ss=0
	if e:GetLabel()>0xffff then
		ss=Duel.SpecialSummon(c,0,tp,1-tp,false,false,POS_FACEUP,dis/0x10000)
	else
		ss=Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,dis)
	end
	if ss>0 then
		local seq=c:GetSequence()
		local p=c:GetControler()
		local g=Group.CreateGroup()
		local tc=Duel.GetFieldCard(p,LOCATION_SZONE,seq)
		if tc then
			g:AddCard(tc)
		end
		if seq>0 then
			tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq-1)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq<4 then
			tc=Duel.GetFieldCard(p,LOCATION_MZONE,seq+1)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==1 then
			tc=Duel.GetFieldCard(p,LOCATION_MZONE,5)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-p,LOCATION_MZONE,6)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==3 then
			tc=Duel.GetFieldCard(p,LOCATION_MZONE,6)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-p,LOCATION_MZONE,5)
			if tc then
				g:AddCard(tc)
			end
		end
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c52644012.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsRace(RACE_ROCK) end
end
function c52644012.chop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(RACE_ROCK)
        c:RegisterEffect(e1)
    end
end
function c52644012.indcon(e)
    return e:GetHandler():IsRace(RACE_ROCK)
end
function c52644012.hspcon(e)
	return e:GetHandler():IsRace(RACE_PYRO)
end
function c52644012.hspfilter(c,e,tp)
    return (c:IsSetCard(0x5f4) or c:IsSetCard(0xef5)) and not c:IsCode(52644012) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c52644012.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c52644012.hspfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c52644012.hspop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c52644012.hspfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_RACE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(RACE_ROCK)
			c:RegisterEffect(e1)
		end
    end
end
