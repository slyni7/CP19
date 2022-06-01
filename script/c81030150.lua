--rokka-chan

function c81030150.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81030150,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,81030150)
	e1:SetCost(c81030150.spco)
	e1:SetTarget(c81030150.sptg)
	e1:SetOperation(c81030150.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--(grave)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81030150,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81030150)
	e2:SetTarget(c81030150.gstg)
	e2:SetOperation(c81030150.gsop)
	c:RegisterEffect(e2)
	
end

--special summon
function c81030150.spcofilter(c)
	return c:IsDestructable() and c:IsFaceup() and c:IsSetCard(0xca3)
end
function c81030150.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c81030150.spcofilter,tp,LOCATION_ONFIELD,0,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,c81030150.spcofilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end

function c81030150.sptgfilter(c,e,tp)
	return ( c:IsSetCard(0xca3) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_TUNER) )
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81030150.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
		Duel.IsExistingMatchingCard(c81030150.sptgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function c81030150.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81030150.sptgfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c81030150.splm(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetAttribute()~=ATTRIBUTE_WATER
end

--special summon(grave)
function c81030150.gstgfilter(c,e,tp)
	return c:IsSetCard(0xca3) and c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81030150.gstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81030150.gstgfilter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81030150.gstgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81030150.gstgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function c81030150.gsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
		and Duel.SendtoGrave(c,REASON_EFFECT) and c:IsLocation(LOCATION_GRAVE) 
		then
			local tc=Duel.GetFirstTarget()
			if tc:IsRelateToEffect(e) 
				then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
	end
end
