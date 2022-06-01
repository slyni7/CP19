--엔듀미온×메테아 (EQ. 세레네)
function c112500037.initial_effect(c)
	--module summon
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,c112500037.pfil1,aux.FilterBoolFunction(Card.IsSetCard,0xe83),1,99,nil)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetDescription(aux.Stringid(112500037,0))
	e3:SetCondition(c112500037.spcon)
	e3:SetTarget(c112500037.sptg)
	e3:SetOperation(c112500037.spop)
	c:RegisterEffect(e3)
	--attack twice
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112500037,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c112500037.atcon)
	e1:SetTarget(c112500037.attg)
	e1:SetOperation(c112500037.atop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112500037,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,112500037)
	e2:SetCondition(c112500037.setcon)
	e2:SetTarget(c112500037.settg)
	e2:SetOperation(c112500037.setop)
	c:RegisterEffect(e2)
	--sp summon
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetDescription(aux.Stringid(112500037,3))
	e0:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_DESTROYED)
	e0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e0:SetTarget(c112500037.tg2)
	e0:SetOperation(c112500037.op2)
	c:RegisterEffect(e0)
end
function c112500037.pfil1(c)
	return c:IsLevelAbove(5)
end
function c112500037.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_MODULE)
end
function c112500037.spfilter(c,e,tp)
	return c:IsSetCard(0xe83) and not c:IsSetCard(0xe84) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c112500037.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c112500037.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c112500037.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c112500037.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c112500037.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112500037.atcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c112500037.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe83) and c:GetEffectCount(EFFECT_EXTRA_ATTACK)==0
end
function c112500037.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c112500037.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c112500037.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c112500037.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c112500037.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c112500037.setcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c112500037.filter0(c)
	return c:IsSetCard(0xe83) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c112500037.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c112500037.filter0,tp,LOCATION_DECK,0,1,nil) end
end
function c112500037.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c112500037.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end
function c112500037.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c112500037.filter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c112500037.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c112500037.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c112500037.filter2(c,e,tp)
	return c:IsCode(112500015) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end