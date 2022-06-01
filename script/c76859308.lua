--넥서스 에리카
function c76859308.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetCountLimit(1,76859308+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c76859308.tg1)
	e1:SetOperation(c76859308.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76859308,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,76859309)
	e2:SetCondition(c76859308.con2)
	e2:SetCost(c76859308.cost2)
	e2:SetTarget(c76859308.tg2)
	e2:SetOperation(c76859308.op2)
	c:RegisterEffect(e2)
end
function c76859308.tfilter1(c)
	return (c:IsSetCard(0x2c5) or c:IsType(TYPE_TRAP)) and c:IsAbleToGrave()
end
function c76859308.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859308.tfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
			and Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c76859308.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDraw(tp) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=nil
	if c:IsRelateToEffect(e) then
		g=Duel.SelectMatchingCard(tp,c76859308.tfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	else
		g=Duel.SelectMatchingCard(tp,c76859308.tfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	end
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c76859308.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c76859308.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c76859308.tfilter21(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859308.tfilter22(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(76859308)
end
function c76859308.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c76859308.tfilter21,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c76859308.tfilter22,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859308.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		return
	end
	local g1=Duel.GetMatchingGroup(c76859308.tfilter21,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c76859308.tfilter22,tp,LOCATION_DECK,0,nil)
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