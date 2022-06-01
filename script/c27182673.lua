--다원마도교사 시스티
function c27182673.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetCost(c27182673.cost1)
	e1:SetTarget(c27182673.tg1)
	e1:SetOperation(c27182673.op1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(27182673,ACTIVITY_CHAIN,c27182673.afilter)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,27182673)
	e2:SetCost(c27182673.cost2)
	e2:SetTarget(c27182673.tg2)
	e2:SetOperation(c27182673.op2)
	c:RegisterEffect(e2)
end
function c27182673.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,27182673)<1
	end
	Duel.RegisterFlagEffect(tp,27182673,RESET_CHAIN,0,1)
end
function c27182673.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSummonable(true,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c27182673.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSummonable(true,nil) then
		Duel.Summon(tp,c,true,nil)
	end
end
function c27182673.afilter(re,tp,cid)
	local rc=re:GetHandler()
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and rc:IsSetCard(0x306e))
end
function c27182673.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(27182673,tp,ACTIVITY_CHAIN)>0 and c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c27182673.tfilter21(c)
	return c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToHand()
end
function c27182673.tfilter22(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x306e) and c:IsAbleToHand()
end
function c27182673.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c27182673.tfilter21,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c27182673.tfilter22,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c27182673.op2(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c27182673.tfilter21,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c27182673.tfilter22,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()>0 and g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg2=g2:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
	end
end