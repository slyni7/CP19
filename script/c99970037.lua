--H. Enchantment: Star Descension
function c99970037.initial_effect(c)

	--무효
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c99970037.condition)
	e1:SetTarget(c99970037.target)
	e1:SetOperation(c99970037.activate)
	e1:SetCountLimit(1,99970037+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	
	--효과 부여
	local ex=Effect.CreateEffect(c)
	ex:SetDescription(aux.Stringid(99970037,0))
	ex:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	ex:SetCategory(CATEGORY_SPECIAL_SUMMON)
	ex:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
	ex:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	ex:SetCode(EVENT_SPSUMMON_SUCCESS)
	ex:SetCondition(c99970037.spcon)
	ex:SetTarget(c99970037.sptg)
	ex:SetOperation(c99970037.spop)
	c:RegisterEffect(ex)
	
end

--무효
function c99970037.cfilter(c)
	return c:IsPosition(POS_FACEUP) and c:IsSetCard(0xd32)
end
function c99970037.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not Duel.IsExistingMatchingCard(c99970037.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c99970037.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c99970037.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--효과 부여
function c99970037.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xd32) and c:GetSummonType()==SUMMON_TYPE_XYZ
end
function c99970037.spfilter(c,e,tp)
	return c:IsSetCard(0xd32)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970037.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99970037.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99970037.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99970037.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

