--흑곡의 호랑거미

function c81050060.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81050060)
	e1:SetCost(c81050060.spco)
	e1:SetTarget(c81050060.sptg)
	e1:SetOperation(c81050060.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	
	--extra summoning
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81050060,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,81050061)
	e3:SetCondition(c81050060.sgcn)
	e3:SetTarget(c81050060.sgtg)
	e3:SetOperation(c81050060.sgop)
	c:RegisterEffect(e3)
	
end

--special summon
function c81050060.spcofilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca6)
	   and	( c:IsLocation(LOCATION_HAND) or c:IsFaceup() )
end
function c81050060.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=LOCATION_MZONE+LOCATION_HAND
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then loc=LOCATION_MZONE end
	if chk==0 then return 
				Duel.IsExistingMatchingCard(c81050060.spcofilter,tp,loc,0,1,c)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81050060.spcofilter,tp,loc,0,1,1,c)
	Duel.Release(g,REASON_COST)
end

function c81050060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end

function c81050060.spopfilter(c,e,tp)
	return c:IsLevelBelow(3) and ( c:IsType(TYPE_MONSTER) and c:IsSetCard(0xca6) )
	   and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81050060.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetReset(RESET_EVENT+0x47e0000)
		c:RegisterEffect(e1,true)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c81050060.spopfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81050060,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81050060.splm)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c81050060.splm(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end

--extra summoning
function c81050060.sgcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_SUMMON and c:GetReasonCard():IsRace(RACE_INSECT)
end

function c81050060.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) end
end

function c81050060.sgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xca6))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,81050060,RESET_PHASE+PHASE_END,0,1)
end
