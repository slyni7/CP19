--[ Pioneer ]
local m=99970597
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,cm.mfilter,nil,1,99,nil)

	--효과 내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(YuL.turn(1))
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	
	--관통 데미지
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e6)
	
end

--모듈 소환
function cm.mfilter(c)
	return c:IsCode(99970591) and c:IsAttribute(ATT_L)
end

--효과 내성
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
