--루나틱션 에우로파
function c112600187.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,112600187)
	e1:SetCondition(c112600187.spcon)
	c:RegisterEffect(e1)
	--attack limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e6)
end
function c112600187.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe8b) and c:GetCode()~=112600187
end
function c112600187.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c112600187.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end