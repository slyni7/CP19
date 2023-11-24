--[ Star Absorber ]
local s,id=GetID()
function s.initial_effect(c)

	local es=MakeEff(c,"S","M")
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetValue(function(e,c) return c:GetLevel()*100 end)
	c:RegisterEffect(es)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.spcon)
	c:RegisterEffect(e3)
	
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0xd36),tp,LOCATION_MZONE,0,1,nil)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in g:Iter() do
		tc:AddCounter(0x1051,1)
	end
end