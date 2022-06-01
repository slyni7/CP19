--인조천사 파티엔티아
local m=99000381
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,cm.sfilter1,cm.sfilter1,nil,cm.sfilter2,1,1)
	c:EnableReviveLimit()
	--double tuner
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetCode(21142671)
	c:RegisterEffect(ea)
	--Prevent Activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	c:RegisterEffect(e1)
	--disable summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetSpellSpeed(3)
	e2:SetCondition(cm.discon)
	e2:SetCost(cm.discost)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetSpellSpeed(3)
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetSpellSpeed(3)
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	--xyz summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetSpellSpeed(3)
	e5:SetTarget(cm.xyztg)
	e5:SetOperation(cm.xyzop)
	c:RegisterEffect(e5)
end
function cm.sfilter1(c)
	return c:IsType(TYPE_TUNER) and (c:IsSetCard(0xc12) or c:IsCode(16946850))
end
function cm.sfilter2(c)
	return c:IsRace(RACE_FAIRY)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsRace(RACE_FAIRY) and re:IsActiveType(TYPE_MONSTER)
end
function cm.Synthetic_Seraphim_filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_FAIRY)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.Synthetic_Seraphim_filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) then
		return Duel.GetCurrentChain()==0
	else
		return e:GetHandler():GetFlagEffect(m)<1 and Duel.GetCurrentChain()==0
	end
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
		e:GetHandler():RegisterEffect(e1,true)
		local res=Duel.CheckLPCost(tp,math.min(e:GetHandler():GetAttack(),e:GetHandler():GetDefense()))
		e1:Reset()
		return res
	end
	e:SetLabel(0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
	e:GetHandler():RegisterEffect(e1,true)
	Duel.PayLPCost(tp,math.min(e:GetHandler():GetAttack(),e:GetHandler():GetDefense()))
	e1:Reset()
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,eg:GetCount(),0,0)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(cm.sumlimit)
	e1:SetLabel(eg:GetFirst():GetCode())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
end
function cm.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function cm.xyzlv(e,c,rc)
	return e:GetHandler():GetLevel()+0x40000
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_MUST_BE_XMATERIAL)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,0)
		e:GetHandler():RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(cm.xyzlv)
		e:GetHandler():RegisterEffect(e2,true)
		local res=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,2)
		e1:Reset()
		e2:Reset()
		return res and e:GetHandler():GetFlagEffect(m+10000)==0
	end
	e:GetHandler():RegisterFlagEffect(m+10000,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_MUST_BE_XMATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(cm.xyzlv)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2,true)
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil,2)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil):GetFirst()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e3:SetOperation(cm.regop)
		sg:RegisterEffect(e3)
		Duel.XyzSummon(tp,sg,nil,c)
	else
		e1:Reset()
		e2:Reset()
		e3:Reset()
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetOwner()
	local c=e:GetHandler()
	--remove overlay replace
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.rcon)
	e1:SetOperation(cm.rop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1,true)
	e:Reset()
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler() and bit.band(r,REASON_COST)~=0
		and re:IsActivated() and re:IsActiveType(TYPE_XYZ)
		and re:GetActivateLocation()&LOCATION_MZONE~=0
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	return ev
end