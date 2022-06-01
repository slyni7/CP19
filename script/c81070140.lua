--Thunder-Ghost "Den-Den Taiko"

function c81070140.initial_effect(c)

	--summon method
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcaa),2,2,c81070140.mfilter)
	c:EnableReviveLimit()
	
	--name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(81070000)
	c:RegisterEffect(e1)
	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81070140,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,81070140)
	e2:SetCondition(c81070140.spcn)
	e2:SetTarget(c81070140.sptg)
	e2:SetOperation(c81070140.spop)
	c:RegisterEffect(e2)
	if not c81070140.global_check then
		c81070140.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c81070140.gcop)
		Duel.RegisterEffect(ge1,0)
	end
	
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81070140,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81070141)
	e3:SetCost(c81070140.stco)
	e3:SetTarget(c81070140.sttg)
	e3:SetOperation(c81070140.stop)
	c:RegisterEffect(e3)
	
end

--summon method
function c81070140.mfilter(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end

--special summon
function c81070140.gcop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		Duel.RegisterFlagEffect(rp,81070140,RESET_PHASE+PHASE_END,0,1)
	end
end

function c81070140.spcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,81070140)~=0
end

function c81070140.sptgfilter(c,e,tp)
	return c:IsSetCard(0x1caa) and c:IsType(TYPE_MONSTER)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81070140.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_GRAVE+LOCATION_REMOVED
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c81070140.sptgfilter,tp,loc,0,1,nil,e,tp)
		end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end

function c81070140.spop(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_GRAVE+LOCATION_REMOVED
	local ct=2
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		ct=1
	end
	ct=math.min(ct,Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ct<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81070140.sptgfilter),tp,loc,0,1,ct,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end

--set
function c81070140.stcofilter(c)
	return c:IsAbleToGraveAsCost()
	and c:IsFaceup() and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070140.stco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81070140.stcofilter,tp,LOCATION_SZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81070140.stcofilter,tp,LOCATION_SZONE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070140.sttgfilter(c,rc)
	return c:IsSSetable(true)
	and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
	and not c:IsCode(rc)
end
function c81070140.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81070140.sttgfilter,tp,LOCATION_DECK,0,1,nil,e:GetLabel())
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function c81070140.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81070140.sttgfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if g and Duel.SelectYesNo(tp,aux.Stringid(81070140,2)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end