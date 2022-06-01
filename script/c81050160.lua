--지저의 거미

function c81050160.initial_effect(c)

	--treat
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(81050000)
	c:RegisterEffect(e2)
	
	--summon method
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,81050160)
	e3:SetCondition(c81050160.spcn1)
	e3:SetOperation(c81050160.spop1)
	c:RegisterEffect(e3)
	
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81050160,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81050161)
	e4:SetCondition(c81050160.spcn2)
	e4:SetCost(c81050160.spco2)
	e4:SetTarget(c81050160.sptg2)
	e4:SetOperation(c81050160.spop2)
	c:RegisterEffect(e4)
	
end

--summon method
function c81050160.spcn1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
	   and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0
end

function c81050160.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x47e0000)
	e1:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e1,true)
end

--special summon
function c81050160.spcn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c81050160.spco2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				c:IsReleasable()
			end
	Duel.Release(c,REASON_COST)
end

function c81050160.sptg2filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and ( c:IsLevelBelow(4) and c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER) )
end
function c81050160.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK
	if chk==0 then return
				Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and	Duel.IsExistingMatchingCard(c81050160.sptg2filter,tp,loc,0,1,c,e,tp)
			end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c81050160.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if lc<1 then return end
	if lc>2 then lc=2 end
	if lc>3 then lc=3 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then lc=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.GetMatchingGroup(c81050160.sptg2filter,tp,LOCATION_REMOVED,0,c,e,tp)
	local g2=Duel.GetMatchingGroup(c81050160.sptg2filter,tp,LOCATION_GRAVE,0,c,e,tp)
	local g3=Duel.GetMatchingGroup(c81050160.sptg2filter,tp,LOCATION_HAND,0,c,e,tp)
	local sg=Group.CreateGroup()
	if g1:GetCount()>0
		and ( ( g2:GetCount()==0 and g3:GetCount()==0 ) or Duel.SelectYesNo(tp,aux.Stringid(81050160,1)) )
		then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
	end
	if Duel.IsPlayerAffectedByEffect(tp,47355498) then g2=0 end
	if g2:GetCount()>0
		and ( ( sg:GetCount()==0 and g3:GetCount()==0 ) or Duel.SelectYesNo(tp,aux.Stringid(81050160,2)) )
		then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
	end
	if g3:GetCount()>0
		and ( sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(81050160,3) ) )
		then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=g3:Select(tp,1,1,nil)
		Duel.HintSelection(sg3)
		sg:Merge(sg3)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
