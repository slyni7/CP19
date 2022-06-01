--LMo.54 절제,「싱귤러리티」[C]
local m=112603354
local cm=_G["c"..m]
function cm.initial_effect(c)
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(kaos.highlandercon(LOCATION_DECK))
	e1:SetTarget(cm.sptg1)
	e1:SetOperation(cm.spop1)
	c:RegisterEffect(e1)
	--atkup
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetCode(EFFECT_UPDATE_ATTACK)
	e10:SetRange(LOCATION_MZONE)
	e10:SetValue(cm.atkval)
	c:RegisterEffect(e10)
	local e20=e10:Clone()
	e20:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e20)
	--summon
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetDescription(aux.Stringid(m,1))
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetCondition(kaos.highlandercon(LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE))
	e12:SetCountLimit(1,112603359)
	e12:SetTarget(cm.sptg)
	e12:SetOperation(cm.spop)
	c:RegisterEffect(e12)
	local e21=e12:Clone()
	e21:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e21)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS)
end

cm.messier_number=54

--spsummon1
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

--atkup
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,c:GetControler(),LOCATION_GRAVE,0,nil,nil)
	return g:GetClassCount(Card.GetCode)*100
end

--summon
function cm.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end