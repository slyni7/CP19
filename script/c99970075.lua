--Star Absorber
function c99970075.initial_effect(c)

	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd36),2,2)
	c:EnableReviveLimit()

	--스타 앱소버 공격력
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_SINGLE)
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetRange(LOCATION_MZONE)
	es:SetValue(c99970075.starabsorber)
	c:RegisterEffect(es)
	
	--특수 소환
	local eq=Effect.CreateEffect(c)
	eq:SetDescription(aux.Stringid(99970075,1))
	eq:SetCategory(CATEGORY_SPECIAL_SUMMON)
	eq:SetType(EFFECT_TYPE_IGNITION)
	eq:SetRange(LOCATION_MZONE)
	eq:SetCountLimit(1,99970075)
	eq:SetTarget(c99970075.target)
	eq:SetOperation(c99970075.operation)
	c:RegisterEffect(eq)
	
	--내성 부여
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c99970075.indtg)
	e3:SetCondition(c99970075.condition)
	c:RegisterEffect(e3)
	
end

--스타 앱소버 공격력
function c99970075.starabsorber(e,c)
	return Duel.GetCounter(0,1,1,0x1051)*100
end

--특수 소환
function c99970075.filterQ(c,e,tp,zone)
	return c:IsSetCard(0xd36) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c99970075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c99970075.filterQ,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c99970075.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99970075.filterQ,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end

--내성 부여
function c99970075.indtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c99970075.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd36)
end
function c99970075.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99970075.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=5
end
