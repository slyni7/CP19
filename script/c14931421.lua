--karin link2
function c14931421.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c14931421.matfilter,2,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14931421,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,14931421)
	e1:SetTarget(c14931421.sptg)
	e1:SetOperation(c14931421.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14931421,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,149314211)
	e2:SetCondition(c14931421.thcon)
	e2:SetTarget(c14931421.thtg)
	e2:SetOperation(c14931421.thop)
	c:RegisterEffect(e2)
end
function c14931421.sfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xb93) and c:GetPreviousControler()==tp and not c:IsCode(14931421)
end
function c14931421.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c14931421.sfilter,1,nil,tp)
end
function c14931421.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c14931421.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,14931399,0xb93,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH) then return end
	for i=1,1 do
			local token=Duel.CreateToken(tp,14931399+i)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
end
function c14931421.matfilter(c)
	return c:IsType(TYPE_TOKEN)
end
function c14931421.spfilter(c,e,tp)
	return c:IsSetCard(0xb93) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14931421.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14931421.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c14931421.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c14931421.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
	if g:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
end