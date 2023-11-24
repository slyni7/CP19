--[ Star Absorber ]
local s,id=GetID()
function s.initial_effect(c)

	local es=MakeEff(c,"S","M")
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetValue(function(e,c) return c:GetLevel()*100 end)
	c:RegisterEffect(es)
	
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCL(1,id)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	
	local e2=MakeEff(c,"FC","M")
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_TO_HAND)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	
end

function s.tar3fil(c,e,tp)
	return c:IsLevelBelow(5) and c:IsSetCard(0xd36) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.tar3fil,tp,LOCATION_GRAVE|LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE|LOCATION_HAND)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tar3fil),tp,LOCATION_GRAVE|LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.con2fil(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK) and c:IsReason(REASON_EFFECT) and Duel.IsMainPhase()
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(s.con2fil,1,nil,1-tp)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function s.op2fil(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(s.op2fil,nil,e,1-tp)
	if #sg<=0 then return end
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end

