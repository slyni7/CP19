--[ LIVES HELL ]
local s,id=GetID()
function s.initial_effect(c)

	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e00:SetCode(EVENT_TO_GRAVE)
	e00:SetOperation(s.lives_hell_op)
	c:RegisterEffect(e00)
	
	local e1=MakeEff(c,"Qo","H")
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	local e2=MakeEff(c,"F","G")
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetTarget(function(e,c) return c:IsLevel(5) and c:IsRace(RACE_FIEND) end)
	e2:SetValue(s.efilter)
	e2:SetCondition(function(e) return e:GetHandler():GetFlagEffect(id)~=0 end)
	c:RegisterEffect(e2)

end

function s.lives_hell_op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_ONFIELD) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end

function s.tar1fil(c)
	return c:IsLevel(5) and c:IsRace(RACE_FIEND) and c:IsFaceup()
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.tar1fil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,LOCATION_HAND)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tar1fil,tp,LOCATION_MZONE,0,nil)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and #g>0 then
		local c=e:GetHandler()
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Equip(tp,c,tc,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(2000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(s.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
	end
end
function s.eqlimit(e,c)
	return c:GetControler()==e:GetHandlerPlayer() or e:GetHandler():GetEquipTarget()==c
end
function s.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
