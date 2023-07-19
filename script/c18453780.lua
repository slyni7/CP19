--It's where my demons hide
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSkullProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),nil,nil)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetTR("H",0)
	e1:SetTarget(s.tfil1)
	e1:SetValue(0x1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","M")
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetTR("HM",0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetTarget(s.tfil2)
	c:RegisterEffect(e2)
end
s.custom_type=CUSTOMTYPE_SKULL
function s.tfil1(e,c)
	return (c:IsCode(70781052) or c:IsSetCard(0x2045))
end
function s.tfil2(e,c)
	return c:IsSetCard(0x45) and c:IsType(TYPE_NORMAL)
end