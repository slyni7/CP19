--alice
function c14941402.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,14941402)
	e1:SetCost(c14941402.spcost)
	e1:SetTarget(c14941402.sptg)
	e1:SetOperation(c14941402.spop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c14941402.reptg)
	e2:SetValue(c14941402.repval)
	e2:SetOperation(c14941402.repop)
	c:RegisterEffect(e2)
end
function c14941402.cfilter(c)
	return c:IsSetCard(0xb94) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14941402.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c14941402.cfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c14941402.cfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c14941402.spfilter(c)
	return c:IsLevel(4) and c:IsSetCard(0xb94) and c:IsType(TYPE_MONSTER)
end
function c14941402.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c14941402.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c14941402.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14941402.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c14941402.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb94) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c14941402.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local tc=eg:GetFirst()
		return eg:GetCount()==1 and e:GetHandler():IsAbleToRemove() and eg:IsExists(c14941402.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c14941402.repval(e,c)
	return c14941402.repfilter(c,e:GetHandlerPlayer())
end
function c14941402.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end