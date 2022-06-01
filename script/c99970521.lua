--[Elder Dragon]
local m=99970521
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

	--데미지
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCL(1,m)
	e1:SetCondition(aux.IsDualState)
	e1:SetCost(spinel.relcost)
	e1:SetTarget(YuL.damtg(1,2000))
	e1:SetOperation(YuL.damop)
	c:RegisterEffect(e1)
	
	--대상 내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(aux.IsDualState)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd39))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	
end

--Ok boomer
function cm.boomer(e,te)
	local tc=te:GetHandler()
	return ((te:IsActiveType(TYPE_MONSTER) and tc:IsStatus(STATUS_SPSUMMON_TURN))
		or (te:IsActiveType(YuL.ST) and tc:IsActivateTurn()))
		and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
