--[KATANAGATARI]
local m=99970320
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c)

	--칼의 독
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetOperation(cm.katana)
	c:RegisterEffect(e0)

	--성도방위
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetValue(aux.imval1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
end

--칼의 독
function cm.katana(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if tc and e:GetHandler():IsReason(REASON_EFFECT) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
