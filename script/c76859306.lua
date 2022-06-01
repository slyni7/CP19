--넥서스 아틀리에
function c76859306.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,76859306+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c76859306.con1)
	e1:SetTarget(c76859306.tg1)
	e1:SetOperation(c76859306.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76859306,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,76859307)
	e2:SetCondition(c76859306.con2)
	e2:SetCost(c76859306.cost2)
	e2:SetTarget(c76859306.tg2)
	e2:SetOperation(c76859306.op2)
	c:RegisterEffect(e2)
end
function c76859306.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c76859306.tfilter1(c,e,tp)
	return c:IsSetCard(0x2c5) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859306.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c76859306.tfilter1,tp,LOCATION_DECK,0,nil,e,tp)
		return g:GetClassCount(Card.GetCode)>1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859306.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c76859306.tfilter1,tp,LOCATION_DECK,0,nil,e,tp)
	if g:GetClassCount(Card.GetCode)<2 then
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=g:Select(tp,1,1,nil)
	g1:Merge(g2)
	Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function c76859306.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c76859306.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c76859306.tfilter21(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859306.tfilter22(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(76859306)
end
function c76859306.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c76859306.tfilter21,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c76859306.tfilter22,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859306.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		return
	end
	local g1=Duel.GetMatchingGroup(c76859306.tfilter21,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c76859306.tfilter22,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<1 or g2:GetCount()<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc2=g2:Select(tp,1,1,nil)
	Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SSet(tp,tc2:GetFirst())
end