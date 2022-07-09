--holoX 라플라스 다크니스
local m=111100100
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),2,true)
	--summon
	local e1=cm.AddProcedure(c,1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_STARTUP)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
	if not SpinelTable then SpinelTable={} end
	table.insert(SpinelTable,e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(cm.sumsuc)
	c:RegisterEffect(e3)
end
function cm.AddProcedure(c,required,position,filter,value,description)
	if not required or required < 1 then
		required = 1
	end
	filter = filter or aux.TRUE
	value = value or 0
	local e1=Effect.CreateEffect(c)
	if description then
		e1:SetDescription(description)
	end
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,m)
	e1:SetValue(value)
	e1:SetCondition(cm.Condition(required,filter))
	e1:SetOperation(cm.Operation(required,filter))
	c:RegisterEffect(e1)
	return e1
end
function cm.Check(sg,e,tp,mg)
	return Duel.GetMZoneCount(tp,sg,tp)>0
end
function cm.Condition(required,filter)
	return function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		local mg=Duel.GetMatchingGroup(aux.AND(Card.IsReleasable,filter),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		return aux.SelectUnselectGroup(mg,e,tp,required,required,cm.Check,0)
	end
end
function cm.Operation(required,filter)
	return function(e,tp,eg,ep,ev,re,r,rp,c)
		local g=Duel.SelectMatchingCard(tp,aux.AND(Card.IsReleasable,filter),tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Release(g,REASON_COST)
		g:DeleteGroup()
	end
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	Duel.RegisterEffect(e0,tp)
	Duel.RegisterFlagEffect(tp,m+99000351,0,0,1)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.AnnounceCard(tp)
	local ab=Duel.AnnounceCard(1-tp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetLabel(ac)
	e1:SetTarget(cm.distg)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetLabel(ac)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetLabel(ab)
	e4:SetTarget(cm.distg)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAIN_SOLVING)
	e5:SetLabel(ab)
	e5:SetCondition(cm.discon)
	e5:SetOperation(cm.disop)
	Duel.RegisterEffect(e5,tp)
	local e6=e4:Clone()
	e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e6,tp)
end
function cm.distg(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsOriginalCodeRule(e:GetLabel())
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end