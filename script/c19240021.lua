--이그니아 모스
function c19240021.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c19240021.lcheck)
	c:EnableReviveLimit()

	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,19240021)
	e1:SetCondition(c19240021.descon1)
	e1:SetTarget(c19240021.destg)
	e1:SetOperation(c19240021.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c19240021.descon2)
	c:RegisterEffect(e2)

	--special Summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,19240022)
	e3:SetTarget(c19240021.sptg)
	e3:SetOperation(c19240021.spop)
	c:RegisterEffect(e3)
end

function c19240021.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end

function c19240021.tffilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x192) and not c:IsForbidden()
end

function c19240021.descon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,19240012)
end
function c19240021.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,19240012)
end

function c19240021.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
		and Duel.IsExistingMatchingCard(c19240021.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c19240021.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()


	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc2=Duel.SelectMatchingCard(tp,c19240021.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()

	if tc2 then
		Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end

	end
end



function c19240021.filters(c,e,tp,ft)
	return c:IsSetCard(0x192) and c:GetCode()~=19240021 and c:IsType(TYPE_MONSTER+TYPE_PENDULUM) and (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c19240021.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c19240021.filters,tp,LOCATION_GRAVE,0,1,nil,e,tp,ft) end
end
function c19240021.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c19240021.filters),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end