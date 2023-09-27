--세컨드 라이프(열역학 제2법칙)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Can be activated the turn it was Set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	c:SetUniqueOnField(1,0,id)
	--Neither monster can be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.indestg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Neither monster can be destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.con1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	if s.global_check==nil then
		s.global_check=true
		s[0]={}
		s[1]=Group.CreateGroup()
		s[1]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0x0,TYPE_MONSTER+TYPE_EFFECT,2800,2600,8,RACE_ILLUSION,ATTRIBUTE_FIRE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT,2800,2600,8,RACE_ILLUSION,ATTRIBUTE_FIRE) then
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP)
		--change base attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetValue(1400)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE)
		e2:SetValue(1300)
		c:RegisterEffect(e2)
		c:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
end
function s.indestg(e,c)
	local handler=e:GetHandler()
	return c==handler or c==handler:GetBattleTarget()
end
function s.gop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(0,0xff,0xff)
	local tc=g:GetFirst()
	while tc do
		if not s[1]:IsContains(tc) then
			s[1]:AddCard(tc)
		end
		tc=g:GetNext()
	end
	local sc=s[1]:GetFirst()
	local d0=0
	local d1=0
	while sc do
		local sloc=sc:GetLocation()
		local sp=sc:GetControler()
		if not s[0][sc] then
			s[0][sc]={sloc,sp}
			if sp==0 then
				d1=d1+1
			elseif sp==1 then
				d0=d0+1
			end
		else
			local ploc=s[0][sc][1]
			local pp=s[0][sc][2]
			s[0][sc]={sloc,sp}
			local entrophy={}
			entrophy[0]=1
			entrophy[LOCATION_DECK]=2
			entrophy[LOCATION_EXTRA]=2
			entrophy[LOCATION_GRAVE]=3
			entrophy[LOCATION_REMOVED]=4
			entrophy[LOCATION_HAND]=5
			entrophy[LOCATION_SZONE]=6
			entrophy[LOCATION_MZONE]=7
			if pp==sp and entrophy[ploc] and entrophy[sloc] and entrophy[ploc]<entrophy[sloc] then
				if sp==0 then
					d1=d1+1
				elseif sp==1 then
					d0=d0+1
				end
			end
		end
		sc=s[1]:GetNext()
	end
	if d0>0 then
		Duel.RaiseEvent(Group.CreateGroup(),id,e,0,0,0,d0)
	end
	if d1>0 then
		Duel.RaiseEvent(Group.CreateGroup(),id,e,0,1,1,d1)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==tp then
		Duel.Hint(HINT_CARD,0,id)
		if Duel.Draw(tp,1,REASON_EFFECT)>0 then
			c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
		end
		if c:GetFlagEffect(id)>3 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.NegateRelatedChain(c,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			c:RegisterEffect(e2)
		end
	end
end
function s.con1(e)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SPECIAL+1)
end