--World Vanquisher
local m=112603429
local cm=_G["c"..m]
function cm.initial_effect(c)
	--attack limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e4)
	
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_HAND)
	e6:SetCondition(cm.pccon)
	e6:SetCost(kaos.hdco)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	local e26=Effect.CreateEffect(c)
	e26:SetDescription(aux.Stringid(m,0))
	e26:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e26:SetType(EFFECT_TYPE_IGNITION)
	e26:SetCountLimit(1,m)
	e26:SetRange(LOCATION_HAND)
	e26:SetCondition(cm.sprcon)
	e26:SetCost(kaos.hdco)
	e26:SetTarget(cm.sptg)
	e26:SetOperation(cm.spop)
	c:RegisterEffect(e26)
	
	--Arcaea special summon
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(m,0))
	e16:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e16:SetType(EFFECT_TYPE_QUICK_O)
	e16:SetCode(EVENT_FREE_CHAIN)
	e16:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e16:SetRange(LOCATION_HAND)
	e16:SetCondition(cm.arccon)
	e16:SetCost(cm.hdco)
	e16:SetTarget(cm.sptg)
	e16:SetOperation(cm.spop)
	c:RegisterEffect(e16)
end

--spsummon
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.cfilter(c)
	return c:IsRace(RACE_CYBERSE) and not (c:IsSetCard(0xe96) and not c:IsSetCard(0xe98))
end
function cm.sprcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.acfilter(c)
	return c:IsSetCard(0xe96) and not c:IsSetCard(0xe98)
end
function cm.arccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.acfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.hdco(e,tp,eg,ep,ev,re,r,rp,chk)
   local g=Duel.GetDecktopGroup(1-tp,1)
   if chk==0 then return g:GetCount()>0 and e:GetHandler():IsDiscardable() end
   Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
   Duel.DisableShuffleCheck()
   Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end

function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end