--Unity Resound
local m=99970403
local cm=_G["c"..m]
function cm.initial_effect(c)

	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(Card.IsModuleRace,RACE_FAIRY),aux.FilterBoolFunction(Card.IsModuleSetCard,0xe1b),1,99,nil)

	--발동 제한
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.aclimit)
	e1:SetCondition(cm.accon)
	c:RegisterEffect(e1)

	--추가 공격
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(1)
	c:RegisterEffect(e2)

end

--발동 제한
function cm.accon(e)
	return e:GetHandler():GetEquipCount()>0
end
function cm.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() and re:IsActiveType(TYPE_EQUIP) and not tc:IsSetCard(0xe1b)
end
