--프리릴리즈 스타
local m=18452726
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(cm.con1)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"SC","M")
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
cm.square_mana={ATTRIBUTE_DARK,ATTRIBUTE_FIRE,ATTRIBUTE_DIVINE,ATTRIBUTE_LIGHT}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.con1(e)
	local c=e:GetHandler()
	return c:IsAttackPos()
end
function cm.val1(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end
function cm.tfil2(c,bc)
	local be={c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
	for _,te in pairs(be) do
		local v=te:GetValue()
		if not v or v==1 or v(te,bc) then
			return false
		end
	end
	return not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) and c:IsAttackPos()
	end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a and a~=c and cm.tfil2(a,c) then
		e:SetLabelObject(a)
		a:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	if d and a~=d and cm.tfil2(d,c) then
		e:SetLabelObject(d)
		d:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,m)
	local bc=e:GetLabelObject()
	bc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(bc,REASON_BATTLE+REASON_REPLACE)
end