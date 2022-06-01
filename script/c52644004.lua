--스타폴 메이
function c52644004.initial_effect(c)

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
	e2:SetCountLimit(1,52644996)
	e2:SetTarget(c52644004.sptg)
	e2:SetOperation(c52644004.spop)
	c:RegisterEffect(e2)
	--스탠바이에 암석족
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetTarget(c52644004.chtg)
	e3:SetOperation(c52644004.chop)
    c:RegisterEffect(e3)
	--암석족이면 파괴 X
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCondition(c52644004.indcon)
    e4:SetValue(1)
    c:RegisterEffect(e4)
	--화염족이면 회수 -> 암석족
	local e5=Effect.CreateEffect(c)
    e5:SetCategory(CATEGORY_TOHAND)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,52644004)
	e5:SetCondition(c52644004.thcon)
    e5:SetTarget(c52644004.thtg)
    e5:SetOperation(c52644004.thop)
    c:RegisterEffect(e5)

end
function c52644004.spfilter(c)
	return c:IsCode(52644009) and c:IsFaceup()
end
function c52644004.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				or (Duel.IsExistingMatchingCard(c52644004.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
					and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0))
	end
	local dis=0
	if Duel.IsExistingMatchingCard(c52644004.spfilter,tp,LOCATION_ONFIELD,0,1,nil) then
		dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
	else
		dis=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	end
	e:SetLabel(dis)
	if dis<2^16 then
		local seq=math.log(dis,2)
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644001,seq))
	else
		local seq=math.log(dis,2)-16
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644003,seq))
	end
end
function c52644004.spop(e,tp,eg,ep,ev,re,r,rp)
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
function c52644004.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsRace(RACE_ROCK) end
end
function c52644004.chop(e,tp,eg,ep,ev,re,r,rp)
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
function c52644004.indcon(e)
    return e:GetHandler():IsRace(RACE_ROCK)
end
function c52644004.thcon(e)
	return e:GetHandler():IsRace(RACE_PYRO)
end
function c52644004.thfilter1(c)
    return c:IsSetCard(0x5f4) and c:IsAbleToHand()
end
function c52644004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52644004.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c52644004.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,c52644004.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
    if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
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
