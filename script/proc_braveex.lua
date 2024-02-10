CUSTOMTYPE_BRAVE=0x40000000
CUSTOMREASON_BRAVE=0x8
EFFECT_SET_BASE_BRAVE=123450000
EFFECT_UPDATE_BRAVE=123450001
EFFECT_SET_BRAVE=123450002
EFFECT_SET_BRAVE_FINAL=123450003
EVENT_BURNED=123450004
FLAGEFFECT_BURNING_ZONE=123450005

if not EFFECT_BRAVE then
	EFFECT_BRAVE=10170016
end

Auxiliary.BurningZoneTopCard={}
Auxiliary.BurningZoneCount={0,0}
local ge2=Effect.GlobalEffect()
ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
ge2:SetCode(EVENT_ADJUST)
ge2:SetOperation(Auxiliary.BurningZoneTopCardOperation)
Duel.RegisterEffect(ge2,0)

function Auxiliary.BurningZoneTopCardOperation(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		local bz=Auxiliary.BurningZone[p]
		local topcard=nil
		if #bz>0 then
			topcard=bz[#bz]:GetOriginalCode()
		end
		if topcard~=Auxiliary.BurningZoneTopCard[p] or #bz~=Auxiliary.BurningZoneCount[p] then
			Auxiliary.BurningZoneTopCard[p]=topcard
			Auxiliary.BurningZoneCount[p]=#bz
			Duel.Hint(HINT_SKILL_REMOVE,p,0)
			if topcard then
				Duel.Hint(HINT_SKILL,p,topcard)
			end
		end
	end
end

function Auxiliary.EraseFromBurningZone(g)
	local tc=g:GetFirst()
	while tc do
		for p=0,1 do
			local bz=Auxiliary.BurningZone[p]
			for i=1,#bz do
				if tc==bz[i] then
					table.remove(bz,i)
					break
				end
			end
			Auxiliary.BurningZoneTopCardOperation(e,tp,eg,ep,ev,re,r,rp)
		end
		tc=g:GetNext()
	end
end

function Auxiliary.AddBraveProcedure(c,f,min,max,gf)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetDescription(aux.Stringid(18453334,0))
	e1:SetCondition(Auxiliary.BraveCondition(f,min,max,gf))
	e1:SetTarget(Auxiliary.BraveTarget(f,min,max,gf))
	e1:SetOperation(Auxiliary.BraveOperation(f,min,max,gf))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_BRAVE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE)
	c:RegisterEffect(e2)
	local mt=getmetatable(c)
	mt.CardType_Brave=true
	return e1
end

if not Auxiliary.BraveRewrite then
	Auxiliary.BraveRewrite=true

local cregeff=Card.RegisterEffect

function Card.RegisterEffect(c,e,...)
	if e:IsHasType(EFFECT_TYPE_SINGLE) then
		if e:GetCode()==EFFECT_SET_BASE_ATTACK then
			local cond=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				return (not cond or cond(e)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_UPDATE_ATTACK then
			local cond=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				return (not cond or cond(e)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_SET_ATTACK then
			local cond=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				return (not cond or cond(e)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_SET_ATTACK_FINAL then
			local cond=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				return (not cond or cond(e)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_SET_BASE_BRAVE then
			local cond=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				return (not cond or cond(e)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_SET_BASE_ATTACK)
		elseif e:GetCode()==EFFECT_UPDATE_BRAVE then
			local cond=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				return (not cond or cond(e)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_UPDATE_ATTACK)
		elseif e:GetCode()==EFFECT_SET_BRAVE then
			local cond=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				return (not cond or cond(e)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_SET_ATTACK)
		elseif e:GetCode()==EFFECT_SET_BRAVE_FINAL then
			local cond=e:GetCondition()
			e:SetCondition(function(e)
				local c=e:GetHandler()
				return (not cond or cond(e)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_SET_ATTACK_FINAL)
		end
	elseif e:IsHasType(EFFECT_TYPE_FIELD) then
		if e:GetCode()==EFFECT_SET_BASE_ATTACK then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_UPDATE_ATTACK then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_SET_ATTACK then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_SET_ATTACK_FINAL then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_SET_BASE_BRAVE then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_SET_BASE_ATTACK)
		elseif e:GetCode()==EFFECT_UPDATE_BRAVE then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_UPDATE_ATTACK)
		elseif e:GetCode()==EFFECT_SET_BRAVE then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_SET_ATTACK)
		elseif e:GetCode()==EFFECT_SET_BRAVE_FINAL then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_SET_ATTACK_FINAL)
		end
	end
	cregeff(c,e,...)
end

local dregeff=Duel.RegisterEffect

function Duel.RegisterEffect(e,...)
	if e:IsHasType(EFFECT_TYPE_FIELD) then
		if e:GetCode()==EFFECT_SET_BASE_ATTACK then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_UPDATE_ATTACK then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_SET_ATTACK then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_SET_ATTACK_FINAL then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and not c:IsHasEffect(EFFECT_BRAVE)
			end)
		elseif e:GetCode()==EFFECT_SET_BASE_BRAVE then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_SET_BASE_ATTACK)
		elseif e:GetCode()==EFFECT_UPDATE_BRAVE then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_UPDATE_ATTACK)
		elseif e:GetCode()==EFFECT_SET_BRAVE then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_SET_ATTACK)
		elseif e:GetCode()==EFFECT_SET_BRAVE_FINAL then
			local tar=e:GetTarget()
			e:SetTarget(function(e,c)
				return (not tar or tar(e,c)) and c:IsHasEffect(EFFECT_BRAVE)
			end)
			e:SetCode(EFFECT_SET_ATTACK_FINAL)
		end
	end
	dregeff(e,...)

end

local cgatk=Card.GetAttack
function Card.GetAttack(c,...)
	if c:IsHasEffect(EFFECT_BRAVE) then
		return 0xefe8efe8efe8efe8
	end
	return cgatk(c,...)
end
function Card.GetBrave(c,...)
	if not c:IsHasEffect(EFFECT_BRAVE) then
		return 0xefe8efe8efe8efe8
	end
	return cgatk(c,...)
end

local cgbatk=Card.GetBaseAttack
function Card.GetBaseAttack(c,...)
	if c:IsHasEffect(EFFECT_BRAVE) then
		return 0xefe8efe8efe8efe8
	end
	return cgbatk(c,...)
end
function Card.GetBaseBrave(c,...)
	if not c:IsHasEffect(EFFECT_BRAVE) then
		return 0xefe8efe8efe8efe8
	end
	return cgbatk(c,...)
end

local cgtatk=Card.GetTextAttack
function Card.GetTextAttack(c,...)
	if c:IsHasEffect(EFFECT_BRAVE) then
		return 0xefe8efe8efe8efe8
	end
	return cgtatk(c,...)
end
function Card.GetTextBrave(c,...)
	if not c:IsHasEffect(EFFECT_BRAVE) then
		return 0xefe8efe8efe8efe8
	end
	return cgtatk(c,...)
end

local cgpatk=Card.GetPreviousAttackOnField
function Card.GetPreviousAttackOnField(c,...)
	if c:IsHasEffect(EFFECT_BRAVE) then
		return 0xefe8efe8efe8efe8
	end
	return cgpatk(c,...)
end
function Card.GetPreviousBraveOnField(c,...)
	if not c:IsHasEffect(EFFECT_BRAVE) then
		return 0xefe8efe8efe8efe8
	end
	return cgpatk(c,...)
end

local ciatk=Card.IsAttack
function Card.IsAttack(c,...)
	if c:IsHasEffect(EFFECT_BRAVE) then
		return false
	end
	return ciatk(c,...)
end
function Card.IsBrave(c,...)
	if not c:IsHasEffect(EFFECT_BRAVE) then
		return false
	end
	return ciatk(c,...)
end

local ciatkb=Card.IsAttackBelow
function Card.IsAttackBelow(c,...)
	if c:IsHasEffect(EFFECT_BRAVE) then
		return false
	end
	return ciatkb(c,...)
end
function Card.IsBraveBelow(c,...)
	if not c:IsHasEffect(EFFECT_BRAVE) then
		return false
	end
	return ciatkb(c,...)
end

local ciatka=Card.IsAttackAbove
function Card.IsAttackAbove(c,...)
	if c:IsHasEffect(EFFECT_BRAVE) then
		return false
	end
	return ciatka(c,...)
end
function Card.IsBraveAbove(c,...)
	if not c:IsHasEffect(EFFECT_BRAVE) then
		return false
	end
	return ciatka(c,...)
end

function Card.GetBraveAttack(c,bc)
	return c:GetAttack()
end

end

function Auxiliary.BraveConditionFilter(c,bc,f)
	return c:IsFaceup() and (not f or f(c)) and c:GetBraveAttack(bc)>0
		--and c:IsCanBeBraveMaterial(bc)
end
function Auxiliary.BraveCheckGoal(sg,tp,bc,gf,min)
	return (not gf or gf(sg)) and sg:CheckWithSumGreater(Card.GetBraveAttack,bc:GetBrave(),bc)
		and not Auxiliary.BraveCheckOverfit(sg,tp,bc,gf,min)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Auxiliary.BraveCheckOverfit(sg,tp,bc,gf,min)
	if #sg==min then
		return false
	end
	local tc=g:GetFirst()
	while tc do
		local tg=sg:Clone()
		tg:RemoveCard(tc)
		if (not gf or gf(tg)) and tg:CheckWithSumGreater(Card.GetBraveAttack,bc:GetBrave()) then
			return true
		end
		tc=g:GetNext()
	end
	return false
end
function Auxiliary.BraveCondition(f,min,max,gf)
	return
		function(e,c)
			if c==nil then
				return true
			end
			if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then
				return false
			end
			local tp=c:GetControler()
			local mg=Duel.GetMatchingGroup(Auxiliary.BraveConditionFilter,tp,LOCATION_MZONE,0,nil,c,f)
			return mg:CheckSubGroup(Auxiliary.BraveCheckGoal,min,max,tp,c,gf,min)
		end
end
function Auxiliary.BraveTarget(f,min,max,gf)
	return
		function(e,tp,eg,ep,ev,re,r,rp,chk,c)
			local mg=Duel.GetMatchingGroup(Auxiliary.BraveConditionFilter,tp,LOCATION_MZONE,0,nil,c,f)
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(123450000,1))
			local cancel=Duel.IsSummonCancelable()
			local sg=mg:SelectSubGroup(tp,Auxiliary.BraveCheckGoal,cancel,min,max,tp,c,gf,min)
			if sg then
				sg:KeepAlive()
				e:SetLabelObject(sg)
				return true
			else
				return false
			end
		end
end

Auxiliary.BurningZone={}
for p=0,1 do
	Auxiliary.BurningZone[p]={}
end

function Auxiliary.BraveOperation(f,min,max,gf)
	return
		function(e,tp,eg,ep,ev,re,r,rp,c)
			local g=e:GetLabelObject()
			local tc=g:GetFirst()
			while tc do
				tc:RegisterFlagEffect(FLAGEFFECT_BURNING_ZONE,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE,0,0)
				tc=g:GetNext()
			end
			Duel.SendtoDeck(g,nil,-2,REASON_DESTROY+REASON_MATERIAL)
			c:SetMaterial(g)
			local tc=g:GetFirst()
			while tc do
				table.insert(Auxiliary.BurningZone[tc:GetControler()],tc)
				Auxiliary.BurningZoneTopCardOperation(e,tp,eg,ep,ev,re,r,rp)
				tc=g:GetNext()
			end
			local tc=g:GetFirst()
			while tc do
				Duel.RaiseSingleEvent(tc,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_BRAVE,tp,tp,0)
				tc=g:GetNext()
			end
			Duel.RaiseEvent(g,EVENT_BE_CUSTOM_MATERIAL,e,CUSTOMREASON_BRAVE,tp,tp,0)
			g:DeleteGroup()
		end
end

local cregeff=Card.RegisterEffect
function Card.RegisterEffect(c,e,forced,...)
	local code=c:GetOriginalCode()
	local mt=_G["c"..code]
	cregeff(c,e,forced,...)
	if e:GetType()&EFFECT_TYPE_SINGLE~=0 and e:GetType()&(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_TRIGGER_F)~=0 then
		local con=e:GetCondition()
		e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			local c=e:GetHandler()
			if c:GetLocation()==0 and c:GetFlagEffect(FLAGEFFECT_BURNING_ZONE)==0 then
				return false
			end
			return not con or con(e,tp,eg,ep,ev,re,r,rp)
		end)
	end
end

--융합 타입 삭제

	local type=Card.GetType
	Card.GetType=function(c)
	if c.CardType_Brave then
		return bit.bor(type(c),TYPE_LINK)-TYPE_LINK
	end
	return type(c)
end
--
	local otype=Card.GetOriginalType
	Card.GetOriginalType=function(c)
	if c.CardType_Brave then
		return bit.bor(otype(c),TYPE_LINK)-TYPE_LINK
	end
	return otype(c)
end
--
	local ftype=Card.GetFusionType
	Card.GetFusionType=function(c)
	if c.CardType_Brave then
		return bit.bor(ftype(c),TYPE_LINK)-TYPE_LINK
	end
	return ftype(c)
end
--
	local ptype=Card.GetPreviousTypeOnField
	Card.GetPreviousTypeOnField=function(c)
	if c.CardType_Brave then
		return bit.bor(ptype(c),TYPE_LINK)-TYPE_LINK
	end
	return ptype(c)
end
--
	local itype=Card.IsType
	Card.IsType=function(c,t)
	if c.CardType_Brave then
		if t==TYPE_LINK then
			return false
		end
		return itype(c,bit.bor(t,TYPE_LINK)-TYPE_LINK)
	end
	return itype(c,t)
end
--
	local iftype=Card.IsFusionType
	Card.IsFusionType=function(c,t)
	if c.CardType_Brave then
		if t==TYPE_LINK then
			return false
		end
		return iftype(c,bit.bor(t,TYPE_LINK)-TYPE_LINK)
	end
	return iftype(c,t)
end