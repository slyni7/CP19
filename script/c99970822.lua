--[ Episode# ]
local s,id=GetID()
function s.initial_effect(c)

	--1
	local e1=MakeEff(c,"STo")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCL(1,id)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--2
	local e3=Effect.CreateEffect(c)
	e3:SetD(id,0)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_TRIGGER_O)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.con3)
	e3:SetTarget(s.tar3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
	
end

--1
function s.tar1fil(c,e,tp)
	return c:IsSetCard(0x5d6e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.tar1fil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tar1fil),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--2
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(0x5d6e) and e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.tar3fil(c)
	return c:IsSetCard(0x5d6e) and c:IsST() and c:IsSSetable()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tar3fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.tar3fil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end

