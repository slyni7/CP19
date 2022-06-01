--정신 지배 기술자
function c47800004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,47800004)
	e1:SetCondition(c47800004.spcon)
	c:RegisterEffect(e1)

	--ctrl
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47800004,0))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,47800005)
	e3:SetCondition(c47800004.condition)
	e3:SetOperation(c47800004.operation)
	c:RegisterEffect(e3)
end


function c47800004.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800004.spcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c47800004.filter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end

function c47800004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>3
end

function c47800004.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<4 then return end
	local dg=g:RandomSelect(tp,1)
	local t=dg:GetFirst()
	while t do
	Duel.GetControl(t,tp)
	t=dg:GetNext()
	end
end
