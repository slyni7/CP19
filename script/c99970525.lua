--[Elder Dragon]
local m=99970525
local cm=_G["c"..m]
function cm.initial_effect(c)

	--듀얼
	aux.EnableDualAttribute(c)
	
	--Ok boomer
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e01:SetCode(EFFECT_IMMUNE_EFFECT)
	e01:SetRange(LOCATION_MZONE)
	e01:SetCondition(aux.IsDualState)
	e01:SetValue(cm.boomer)
	c:RegisterEffect(e01)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.sprcon)
	c:RegisterEffect(e1)
	
	--재차 소환 취급
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_PRE_MATERIAL)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	
end

--Ok boomer
function cm.boomer(e,te)
	local tc=te:GetHandler()
	return ((te:IsActiveType(TYPE_MONSTER) and tc:IsStatus(STATUS_SPSUMMON_TURN))
		or (te:IsActiveType(YuL.ST) and tc:IsActivateTurn()))
		and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--특수 소환
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

--재차 소환 취급
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return r==REASON_SUMMON and rc:IsFaceup() and rc:IsType(TYPE_DUAL)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_STATUS)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1)
end
