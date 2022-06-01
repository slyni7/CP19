--흑곡의 애어리염낭

function c81050030.initial_effect(c)
	
	--special summon(e1,2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c81050030.gptg)
	e1:SetOperation(c81050030.gpop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	
	--special summon(e3)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81050030,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,81050030)
	e3:SetCondition(c81050030.hpcn)
	e3:SetTarget(c81050030.hptg)
	e3:SetOperation(c81050030.hpop)
	c:RegisterEffect(e3)
	
end

--special summon(e1,2)
function c81050030.gptgfilter(c,e,tp)
	return c:IsSetCard(0xca6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81050030.gptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c81050030.gptgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c81050030.gpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81050030.gptgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end

--special summon(e3)
function c81050030.hpcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SUMMON and c:GetReasonCard():IsRace(RACE_INSECT)
end

function c81050030.hptgfilter(c,e,tp)
	return c:IsLevelBelow(4)
	   and c:IsSetCard(0xca6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81050030.hptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c81050030.hptgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp)
			end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c81050030.hpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81050030.hptgfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
	end
end
