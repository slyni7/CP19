--[ Module 2 ]
local m=99970019
local cm=_G["c"..m]
function cm.initial_effect(c)

	YuL.Activate(c)
	
	--직접 공격 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_MODULE))
	c:RegisterEffect(e1)
	
end
