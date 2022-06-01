--인조천사 인두스트리아
local m=99000379
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Synthetic Seraphim
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(99000374,0))
	ea:SetCategory(CATEGORY_SUMMON)
	ea:SetType(EFFECT_TYPE_QUICK_O)
	ea:SetRange(LOCATION_HAND)
	ea:SetCode(EVENT_FREE_CHAIN)
	ea:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	ea:SetSpellSpeed(3)
	ea:SetCondition(cm.Synthetic_Seraphim_Condition1)
	ea:SetTarget(cm.Synthetic_Seraphim_Target)
	ea:SetOperation(cm.Synthetic_Seraphim_Operation)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(99000374,0))
	eb:SetCategory(CATEGORY_SUMMON)
	eb:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	eb:SetRange(LOCATION_HAND)
	eb:SetCode(EVENT_CHAINING)
	eb:SetProperty(EFFECT_FLAG_DELAY)
	eb:SetSpellSpeed(3)
	eb:SetCondition(cm.Synthetic_Seraphim_Condition2)
	eb:SetTarget(cm.Synthetic_Seraphim_Target)
	eb:SetOperation(cm.Synthetic_Seraphim_Operation)
	c:RegisterEffect(eb)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.sumsuc)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetSpellSpeed(3)
	e4:SetCondition(cm.spcon)
	e4:SetCost(cm.spcost)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
	--synchro / xyz
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e5:SetCountLimit(1)
	e5:SetSpellSpeed(3)
	e5:SetTarget(cm.synxyztg)
	e5:SetOperation(cm.synxyzop)
	c:RegisterEffect(e5)
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xc12) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.synxyzfilter(c)
	return c:IsSetCard(0xc12) and (c:IsSynchroSummonable(nil) or c:IsXyzSummonable(nil))
end
function cm.synxyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.synxyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.synxyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.synxyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		if tg:GetFirst():IsSynchroSummonable(nil) then
			Duel.SynchroSummon(tp,tg:GetFirst(),nil)
		elseif tg:GetFirst():IsXyzSummonable(nil) then
			Duel.XyzSummon(tp,tg:GetFirst(),nil)
		end
	end
end
function cm.Synthetic_Seraphim_filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_FAIRY)
end
function cm.Synthetic_Seraphim_Condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.Synthetic_Seraphim_filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
end
function cm.Synthetic_Seraphim_Condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_COUNTER)
end
function cm.Synthetic_Seraphim_Target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsSummonable(true,nil)
		and e:GetHandler():GetFlagEffect(m+99000380)==0
	end
	e:GetHandler():RegisterFlagEffect(m+99000380,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function cm.Synthetic_Seraphim_Operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Summon(tp,c,true,nil)~=0 then
		--nontuner
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_NONTUNER)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e1)
	end
end