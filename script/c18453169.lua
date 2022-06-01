--혜성의 신궁-실
local m=18453169
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,nil,nil,1,99,cm.pfun1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e4:SetValue(cm.val4)
	c:RegisterEffect(e4)
end
function cm.pfun1(g)
	local sg=g:Filter(Card.IsLoc,nil,"S")
	return sg:IsExists(Card.IsModuleCode,1,nil,95638658)
end
function cm.val4(e,dp)
	local c=e:GetHandler()
	local tp=e:GetOwnerPlayer()
	if tp~=dp and c:GetAttack()>=1000 then
		return c:GetAttack()-1000
	end
	return -1
end