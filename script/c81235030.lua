--야상곡 여명의 정원
--카드군 번호: 0xc90
function c81235030.initial_effect(c)

	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81235030,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81235030)
	e1:SetCost(c81235030.co1)
	e1:SetTarget(c81235030.tg1)
	e1:SetOperation(c81235030.op1)
	c:RegisterEffect(e1)
	
	--유발
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81235030,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81235031)
	e2:SetTarget(c81235030.tg2)
	e2:SetOperation(c81235030.op2)
	c:RegisterEffect(e2)
end

--특수소환
function c81235030.filter0(c)
	return c:IsReleasable() and c:IsRace(RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_DARK)
	and ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() )
end
function c81235030.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=0
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then loc=loc+LOCATION_MZONE end
	if ft>0 then loc=loc+LOCATION_MZONE+LOCATION_HAND end
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81235030.filter0,tp,loc,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81235030.filter0,tp,loc,0,1,1,c)
	Duel.Release(g,nil,REASON_COST)
end
function c81235030.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c81235030.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end

--유발
function c81235030.tfilter1(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81235030.tfilter2(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xc90)
end
function c81235030.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function c81235030.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81235030,3))
	local g1=Duel.SelectMatchingCard(1-tp,c81235030.tfilter1,1-tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81235030,3))
	local g2=Duel.SelectMatchingCard(tp,c81235030.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	local sg1=g1:GetFirst()
	local sg2=g2:GetFirst()
	if g1 then
		Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleDeck(1-tp)
	end
	if g2 then
		Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
	end
end


