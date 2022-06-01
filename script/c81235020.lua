--야상곡 무명의 호수
--카드군 번호: 0xc90
function c81235020.initial_effect(c)

	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81235020,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCountLimit(1,81235020)
	e1:SetTarget(c81235020.tg1)
	e1:SetOperation(c81235020.op1)
	c:RegisterEffect(e1)
	
	--유발
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81235020,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SSET)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,81235021)
	e2:SetCost(c81235020.co2)
	e2:SetTarget(c81235020.tg2)
	e2:SetOperation(c81235020.op2)
	c:RegisterEffect(e2)
end

--특수소환
function c81235020.filter0(c,e,tp)
	return c:IsSetCard(0xc90) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not c:IsCode(81235020)
end
function c81235020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if Duel.IsPlayerAffectedByEffect(tp,47355498) then loc=LOCATION_DECK end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c81235020.filter0,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c81235020.op1(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_DECK+LOCATION_GRAVE
	if Duel.IsPlayerAffectedByEffect(tp,47355498) then loc=LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81235020.filter0,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--유발
function c81235020.filter1(c)
	return c:IsSetCard(0xc90) and not c:IsPublic()
end
function c81235020.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81235020.filter1,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c81235020.filter1,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function c81235020.cfilter(c,tp)
	return c:GetOwner()~=tp
end
function c81235020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return eg:IsExists(c81235020.cfilter,1,nil,tp)
	end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c81235020.cfilterA(c,e)
	return c:IsRelateToEffect(e) and c:IsOnField()
end
function c81235020.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c81235020.cfilterA,nil,e,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end


