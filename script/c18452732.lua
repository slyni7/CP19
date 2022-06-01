--폭주천사 리리
local m=18452732
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","M")
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	WriteEff(e1,1,"NCO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","M")
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	WriteEff(e2,1,"C")
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"SC")
	e3:SetCode(EVENT_BATTLED)
	WriteEff(e3,3,"O")
	c:RegisterEffect(e3)
end
cm.square_mana={ATTRIBUTE_FIRE,ATTRIBUTE_EARTH,ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)<1 and (Duel.GetAttacker()==c or Duel.GetAttackTarget()==c)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckLPCost(tp,2000)
	end
	Duel.PayLPCost(tp,2000)
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(3000)
	c:RegisterEffect(e1)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return c:IsAttackPos() and re:IsActiveType(TYPE_MONSTER) and rc:IsLoc("M") and rp~=tp
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAttackable()
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) and c:IsAttackable() then
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(3000)
		c:RegisterEffect(e1)
		Duel.CalculateDamage(c,rc)
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=Duel.GetAttackTarget()
	if bc==c then
		bc=Duel.GetAttacker()
	end
	if not bc or c:IsStatus(STATUS_BATTLE_DESTROYED) or not bc:IsStatus(STATUS_BATTLE_DESTROYED) then
		return
	end
	local e1=MakeEff(c,"F")
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetTR("M","M")
	e1:SetLabelObject(bc)
	e1:SetTarget(cm.otar31)
	Duel.RegisterEffect(e1,tp)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	e2:SetLabelObject(bc)
	e2:SetCondition(cm.ocon32)
	e2:SetOperation(cm.oop32)
	Duel.RegisterEffect(e2,tp)
end
function cm.otar31(e,c)
	local bc=e:GetLabelObject()
	return c:IsOriginalCodeRule(bc:GetOriginalCodeRule())
end
function cm.ocon32(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(bc:GetOriginalCodeRule())
end
function cm.oop32(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end