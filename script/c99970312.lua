--[KATANAGATARI]
local m=99970312
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

	--가장 날카로운 칼
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_SZONE)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	
	--참도 사냥
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetProperty(spinel.delay)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)

end

--칼의 독
function cm.katana(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if tc and e:GetHandler():IsReason(REASON_EFFECT) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

--가장 날카로운 칼
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	if not tc then return false end
	local bc=tc:GetBattleTarget()
	e:SetLabelObject(bc)
	return tc:IsLocation(LOCATION_MZONE) and bc and bc:IsLocation(LOCATION_MZONE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=c:GetEquipTarget()
	if not tc then return false end
	local bc=tc:GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end

--참도 사냥
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and eg:IsContains(ec)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
		and e:GetHandler():GetEquipTarget():IsChainAttackable(0,true) end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if not ec:IsRelateToBattle() then return end
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE+PHASE_DAMAGE_CAL)
	ec:RegisterEffect(e1)
end
