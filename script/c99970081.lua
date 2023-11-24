--[ Star Absorber ]
local s,id=GetID()
function s.initial_effect(c)

	YuL.Activate(c)
	
	local e2=MakeEff(c,"Qo","S")
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_SUMMON)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,id)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(function(e,c) return Duel.GetCounter(0,1,1,0x1051) end)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_UPDATE_RANK)
	c:RegisterEffect(e5)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(function(_,c) return c:IsLevel(1) or c:IsRank(1) end)
	c:RegisterEffect(e1)
	
end

function s.nsfilter(c)
	return c:IsSetCard(0xd36) and c:IsSummonable(true,nil)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,LOCATION_HAND|LOCATION_MZONE)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in g:Iter() do
		tc:AddCounter(0x1051,1)
	end
	local sg=Duel.GetMatchingGroup(s.nsfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,nil)
	if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.Summon(tp,sc,true,nil)
	end
end