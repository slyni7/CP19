--퀸 엘리자베스의 명령
function c81200100.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_PHASE)
	c:RegisterEffect(e1)
	
	--synchro
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81200100,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81200100)
	e2:SetCondition(c81200100.cn)
	e2:SetTarget(c81200100.tg2)
	e2:SetOperation(c81200100.op2)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
	
	--replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetRange(LOCATION_SZONE+LOCATION_HAND)
	e4:SetTarget(c81200100.tg3)
	e4:SetValue(c81200100.va3)
	e4:SetOperation(c81200100.op3)
	c:RegisterEffect(e4)
	
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(81200100,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,81200101)
	e5:SetTarget(c81200100.tg4)
	e5:SetOperation(c81200100.op4)
	c:RegisterEffect(e5)
end

--synchro
function c81200100.cn(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2 )
end
function c81200100.mfilter0(c)
	return c:IsSetCard(0xcb7) and c:IsType(TYPE_MONSTER)
end
function c81200100.mfilter1(c)
	return c:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:IsType(TYPE_MONSTER)
end
function c81200100.filter0(c,syn)
	local b1=true
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		b1=Duel.CheckTunerMaterial(syn,c,nil,c81200100.mfilter0,1,99)
	end
	return b1 and syn:IsSynchroSummonable(c)
end
function c81200100.filter1(c,mg)
	return mg:IsExists(c81200100.filter0,1,nil,c) and c:IsSetCard(0xcb7)
end
function c81200100.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c81200100.mfilter0,tp,LOCATION_MZONE,0,nil)
		local exg=Duel.GetMatchingGroup(c81200100.mfilter1,tp,LOCATION_MZONE,0,nil)
		mg:Merge(exg)
		return Duel.IsExistingMatchingCard(c81200100.filter1,tp,LOCATION_EXTRA,0,1,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c81200100.op2(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c81200100.mfilter0,tp,LOCATION_MZONE,0,nil)
	local exg=Duel.GetMatchingGroup(c81200100.mfilter1,tp,LOCATION_MZONE,0,nil)
	mg:Merge(exg)
	local g=Duel.GetMatchingGroup(c81200100.filter1,tp,LOCATION_EXTRA,0,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:FilterSelect(tp,c81200100.filter0,1,1,nil,sg:GetFirst())
		Duel.SynchroSummon(tp,sg:GetFirst(),tg:GetFirst())
	end
end

--replace
function c81200100.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcb7) and c:IsControler(tp) and c:IsOnField()
	and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c81200100.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
		and eg:IsExists(c81200100.filter2,1,e:GetHandler(),tp)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c81200100.va3(e,c)
	return c81200100.filter2(c,e:GetHandlerPlayer())
end
function c81200100.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end

--spsummon
function c81200100.filter3(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsSetCard(0xcb8) and c:IsType(TYPE_MONSTER)
end
function c81200100.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c81200100.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c81200100.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81200100.filter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0
	and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
	end
end


