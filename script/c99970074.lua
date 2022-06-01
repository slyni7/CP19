--Star Absorber
function c99970074.initial_effect(c)

	--스타 앱소버 공격력
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_SINGLE)
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetRange(LOCATION_MZONE)
	es:SetValue(c99970074.starabsorber)
	c:RegisterEffect(es)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,99970074)
	e2:SetCondition(c99970074.spcon)
	c:RegisterEffect(e2)
	
	--카운터
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetDescription(aux.Stringid(99970074,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(c99970074.operation)
	c:RegisterEffect(e1)

end

--스타 앱소버 공격력
function c99970074.starabsorber(e,c)
	return c:GetLevel()*100
end

--특수 소환
function c99970074.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd36)
end
function c99970074.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99970074.spfilter,tp,LOCATION_MZONE,0,1,nil)
end

--카운터
function c99970074.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1051,1,REASON_EFFECT)
		tc=g:GetNext()
	end
end
