--다섯 번째 계절: 낙원
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e0=MakeEff(c,"S")
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.val0)
	c:RegisterEffect(e0)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_DRAW)
	WriteEff(e1,1,"NTO")
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","M")
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(s.val2)
	c:RegisterEffect(e2)
end
function s.val0(e,c)
	local g=c:GetMaterial()
	local ct=g:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_LIGHT)
	e:SetLabel(ct)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabelObject():GetLabel()
	if chk==0 then
		return ct>0
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local ct=e:GetLabelObject():GetLabel()
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function s.val2(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner()~=e:GetOwner()
end