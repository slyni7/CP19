--μ(마이크로) 벨
local m=11111111
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(cm.tar1)
	c:RegisterEffect(e1)
end
function cm.tar1(e,c)
	return c:GetAttack()~=c:GetBaseAttack()
end