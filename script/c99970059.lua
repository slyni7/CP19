--님프 메모리즈: 베로니카
function c99970059.initial_effect(c)

	--님프 메모리즈 공통효과
	local en=Effect.CreateEffect(c)
	en:SetType(EFFECT_TYPE_SINGLE)
	en:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(en)
	local em=Effect.CreateEffect(c)
	em:SetType(EFFECT_TYPE_FIELD)
	em:SetCode(EFFECT_SPSUMMON_PROC)
	em:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	em:SetRange(LOCATION_HAND)
	em:SetCondition(c99970059.NMcon)
	em:SetOperation(c99970059.NMop)
	c:RegisterEffect(em)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970059,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c99970059.sptg)
	e1:SetOperation(c99970059.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)

	--마함 파괴
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970059,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c99970059.con)
	e2:SetOperation(c99970059.operation)
	e2:SetTarget(c99970059.target)
	c:RegisterEffect(e2)
	
end

--님프 메모리즈 공통 효과
function c99970059.NMfilter(c)
	return c:IsSetCard(0xd35) and c:IsDiscardable()
end
function c99970059.NMcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c99970059.NMfilter,c:GetControler(),LOCATION_HAND,0,1,c)
end
function c99970059.NMop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c99970059.NMfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end

--특수 소환
function c99970059.filter(c,e,tp)
	return c:IsSetCard(0xd35) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c99970059.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c99970059.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99970059.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99970059.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--내성 부여
function c99970059.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c99970059.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c99970059.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970059.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c99970059.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c99970059.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c99970059.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
