--[KATANAGATARI]
local m=99970319
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c)

	--가장 독이 없는 칼
	local e1=MakeEff(c,"I","S")
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)

	--왕도락토
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetValue(cm.atlimit)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","S")
	e3:SetCode(EFFECT_CANNOT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetTarget(cm.rmlimit)
	c:RegisterEffect(e3)
	
end

--가장 독이 없는 칼
function cm.cfil(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsAbleToHandAsCost() and not c:IsCode(m)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfil,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SendtoHand(g,nil,REASON_COST)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if ec and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		ec:RegisterEffect(e1)
	end
end

--왕도락토
function cm.atlimit(e,c)
	return c:GetAttack()<e:GetHandler():GetAttack()
end
function cm.rmlimit(e,c,p)
	return c:IsType(TYPE_MONSTER)
end
