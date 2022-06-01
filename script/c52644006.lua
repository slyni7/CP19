--스타폴 라이덴
function c52644006.initial_effect(c)
	--엑시즈 소환
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5f4),11,2)
    c:EnableReviveLimit()
	--암석족이면 파괴 X
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c52644006.indcon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	--파괴
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52644006,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,52644006)
	e2:SetHintTiming(0,HINT_TIMING_MONSTER_E)
	e2:SetCondition(c52644006.descon)
	e2:SetTarget(c52644006.destg)
	e2:SetOperation(c52644006.desop)
	c:RegisterEffect(e2)
	--종족 바꾸기
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(52644006,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c52644006.cost)
	e3:SetTarget(c52644006.chtg)
	e3:SetOperation(c52644006.chop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(52644006,2))
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetTarget(c52644006.swtg)
	e4:SetOperation(c52644006.swop)
    --c:RegisterEffect(e4)
end
function c52644006.swtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsRace(RACE_ROCK) end
end
function c52644006.swop(e,tp,eg,ep,ev,re,r,rp)
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
function c52644006.indcon(e)
    return e:GetHandler():IsRace(RACE_ROCK)
end
function c52644006.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRace(RACE_PYRO)
end
function c52644006.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=0
	for i=0,4 do
		if Duel.CheckLocation(tp,LOCATION_MZONE,i) and (Duel.GetFieldCard(tp,LOCATION_SZONE,i) 
			or (i>0 and Duel.GetFieldCard(tp,LOCATION_MZONE,i-1))
			or (i<4 and Duel.GetFieldCard(tp,LOCATION_MZONE,i+1))
			or (i==1 and Duel.GetFieldCard(tp,LOCATION_MZONE,5))
			or (i==1 and Duel.GetFieldCard(1-tp,LOCATION_MZONE,6))
			or (i==3 and Duel.GetFieldCard(tp,LOCATION_MZONE,6))
			or (i==3 and Duel.GetFieldCard(1-tp,LOCATION_MZONE,5))) then
			zone=zone+2^i
		end
	end
	for i=0,4 do
		if Duel.CheckLocation(tp,LOCATION_SZONE,i) and (Duel.GetFieldCard(tp,LOCATION_MZONE,i) 
			or (i>0 and Duel.GetFieldCard(tp,LOCATION_SZONE,i-1))
			or (i<4 and Duel.GetFieldCard(tp,LOCATION_SZONE,i+1))) then
			zone=zone+2^(i+8)
		end
	end
	for i=0,4 do
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,i) and (Duel.GetFieldCard(1-tp,LOCATION_SZONE,i) 
			or (i>0 and Duel.GetFieldCard(1-tp,LOCATION_MZONE,i-1))
			or (i<4 and Duel.GetFieldCard(1-tp,LOCATION_MZONE,i+1))
			or (i==1 and Duel.GetFieldCard(1-tp,LOCATION_MZONE,5))
			or (i==1 and Duel.GetFieldCard(tp,LOCATION_MZONE,6))
			or (i==3 and Duel.GetFieldCard(1-tp,LOCATION_MZONE,6))
			or (i==3 and Duel.GetFieldCard(tp,LOCATION_MZONE,5))) then
			zone=zone+2^(i+16)
		end
	end
	for i=0,4 do
		if Duel.CheckLocation(1-tp,LOCATION_SZONE,i) and (Duel.GetFieldCard(1-tp,LOCATION_MZONE,i) 
			or (i>0 and Duel.GetFieldCard(1-tp,LOCATION_SZONE,i-1))
			or (i<4 and Duel.GetFieldCard(1-tp,LOCATION_SZONE,i+1))) then
			zone=zone+2^(i+24)
		end
	end
	if chk==0 then
		return zone>0
	end
	local dis=Duel.SelectDisableField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,0x1f1f1f1f-zone)
	e:SetLabel(dis)
	if dis<2^8 then
		local seq=math.log(dis,2)
		Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644001,seq))
	else
		if dis<2^16 then
			local seq=math.log(dis,2)-8
			Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644002,seq))
		else
			if dis<2^24 then
				local seq=math.log(dis,2)-16
				Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644003,seq))
			else
				local seq=math.log(dis,2)-24
				Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(52644004,seq))
			end
		end
	end
end
function c52644006.desop(e,tp,eg,ep,ev,re,r,rp)
	local dis=e:GetLabel()
	if dis<2^8 then
		local seq=math.log(dis,2)
		local g=Group.CreateGroup()
		local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq)
		if tc then
			g:AddCard(tc)
		end
		if seq>0 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq-1)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq<4 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq+1)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==1 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,5)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
			if tc then
				g:AddCard(tc)
			end
		end
		if seq==3 then
			tc=Duel.GetFieldCard(tp,LOCATION_MZONE,6)
			if tc then
				g:AddCard(tc)
			end
			tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
			if tc then
				g:AddCard(tc)
			end
		end
		Duel.Destroy(g,REASON_EFFECT)
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
	else
		if dis<2^16 then
			local seq=math.log(dis,2)-8
			local g=Group.CreateGroup()
			local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,seq)
			if tc then
				g:AddCard(tc)
			end
			if seq>0 then
				tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq-1)
				if tc then
					g:AddCard(tc)
				end
			end
			if seq<4 then
				tc=Duel.GetFieldCard(tp,LOCATION_SZONE,seq+1)
				if tc then
					g:AddCard(tc)
				end
			end
			Duel.Destroy(g,REASON_EFFECT)
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
		else
			if dis<2^24 then
				local seq=math.log(dis,2)-16
				local g=Group.CreateGroup()
				local tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,seq)
				if tc then
					g:AddCard(tc)
				end
				if seq>0 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq-1)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq<4 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq+1)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq==1 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,5)
					if tc then
						g:AddCard(tc)
					end
					tc=Duel.GetFieldCard(tp,LOCATION_MZONE,6)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq==3 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,6)
					if tc then
						g:AddCard(tc)
					end
					tc=Duel.GetFieldCard(tp,LOCATION_MZONE,5)
					if tc then
						g:AddCard(tc)
					end
				end
				Duel.Destroy(g,REASON_EFFECT)
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
			else
				local seq=math.log(dis,2)-24
				local g=Group.CreateGroup()
				local tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,seq)
				if tc then
					g:AddCard(tc)
				end
				if seq>0 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,seq-1)
					if tc then
						g:AddCard(tc)
					end
				end
				if seq<4 then
					tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,seq+1)
					if tc then
						g:AddCard(tc)
					end
				end
				Duel.Destroy(g,REASON_EFFECT)
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
	end
end
function c52644006.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRace(RACE_ROCK) or e:GetHandler():IsRace(RACE_PYRO) end
end
function c52644006.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetFlagEffect(tp,52644006)==0 end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,52644006,RESET_CHAIN,0,1)
end
function c52644006.chop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsRace(RACE_PYRO) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(RACE_ROCK)
        c:RegisterEffect(e1)
	elseif c:IsFaceup() and c:IsRelateToEffect(e) and c:IsRace(RACE_ROCK) then
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
        e2:SetValue(RACE_PYRO)
        c:RegisterEffect(e2)
    end
end