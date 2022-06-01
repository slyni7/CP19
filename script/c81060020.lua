--지상의 이나바(월토)
--카드군 번호: 0xca7
function c81060020.initial_effect(c)

	--리쿠르트
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81060020)
	e1:SetCondition(c81060020.cn1)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(c81060020.tg1)
	e1:SetOperation(c81060020.op1)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81060020,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,81060021)
	e2:SetTarget(c81060020.tg2)
	e2:SetOperation(c81060020.op2)
	c:RegisterEffect(e2)
end

--리쿠르트
function c81060020.cn1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c81060020.filter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xca7) and not c:IsCode(81060020)
end
function c81060020.ffilter0(c,g)
	return g:IsExists(c81060020.ffilter1,1,c,c:GetCode())
end
function c81060020.ffilter1(c,code)
	return not c:IsCode(code)
end
function c81060020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return false end
		local g=Duel.GetMatchingGroup(c81060020.filter0,tp,LOCATION_DECK,0,nil,e,tp)
		return g:IsExists(c81060020.ffilter0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c81060020.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return false end
	local g=Duel.GetMatchingGroup(c81060020.filter0,tp,LOCATION_DECK,0,nil,e,tp)
	local dg=g:Filter(c81060020.ffilter0,nil,g)
	if dg:GetCount()>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=dg:Select(tp,1,1,nil)
		local tc1=sg:GetFirst()
		dg:Remove(Card.IsCode,nil,tc1:GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc2=dg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end

--서치
function c81060020.cfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca9)
end
function c81060020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81060020.cfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c81060020.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81060020.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end