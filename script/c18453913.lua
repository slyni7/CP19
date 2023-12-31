--위대한 환수 가젯트
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSkullProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,"가젯트"),nil,nil,s.pfun1)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.val1)
	c:RegisterEffect(e1)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetTR("M","M")
	e3:SetTarget(s.tar3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
s.custom_type=CUSTOMTYPE_SKULL
function s.pfun1(g)
	return #g==1
end
function s.val1(e,c)
	local tc=c:GetMaterial():GetFirst()
	local atk=0
	if tc then
		atk=tc:GetTextAttack()*2
	end
	if atk<0 then
		atk=0
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	c:RegisterEffect(e1)
end
function s.tar3(e,c)
	local handler=e:GetHandler()
	return c==handler or c==handler:GetBattleTarget()
end