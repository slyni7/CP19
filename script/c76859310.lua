--넥서스 루미너스
function c76859310.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76859310+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c76859310.tg1)
	e1:SetOperation(c76859310.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76859310,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,76859311)
	e2:SetCondition(c76859310.con2)
	e2:SetCost(c76859310.cost2)
	e2:SetTarget(c76859310.tg2)
	e2:SetOperation(c76859310.op2)
	c:RegisterEffect(e2)
end
function c76859310.tfilter11(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c76859310.tfilter12(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_TRAP) and c:IsAbleToGrave()
end
function c76859310.tfilter13(c,e)
	return (c:IsSetCard(0x2c5) or c:IsType(TYPE_TRAP)) and c:IsAbleToDeck() and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsCanBeEffectTarget(e)
end
function c76859310.tfilter14(c,g,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<4 then
		res=g:IsExists(c76859310.tfilter14,1,sg,g,sg)
	else
		res=(sg:FilterCount(Card.IsSetCard,nil,0x2c5)>1 and sg:FilterCount(Card.IsType,nil,TYPE_TRAP)>1)
	end
	sg:RemoveCard(c)
	return res
end
function c76859310.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	local v1=(Duel.IsExistingMatchingCard(c76859310.tfilter11,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(c76859310.tfilter12,tp,LOCATION_DECK,0,1,nil))
	local g2=Duel.GetMatchingGroup(c76859310.tfilter13,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg=Group.CreateGroup()
	local v2=(g2:IsExists(c76859310.tfilter14,1,sg,g2,sg) and Duel.IsPlayerCanDraw(tp,2))
	if chk==0 then
		return (v1 or v2)
	end
	if v1 and v2 then
		local opt=Duel.SelectOption(tp,aux.Stringid(76859310,1),aux.Stringid(76859310,2))
		e:SetLabel(opt)
	elseif v1 then
		e:SetLabel(0)
	else
		e:SetLabel(1)
	end
	if e:GetLabel()==0 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		while sg:GetCount()<4 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg=g2:FilterSelect(tp,c76859310.tfilter14,1,1,sg,g2,sg)
			sg:Merge(tg)
		end
		Duel.SetTargetCard(sg)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,4,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function c76859310.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local g1=Duel.GetMatchingGroup(c76859310.tfilter11,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(c76859310.tfilter12,tp,LOCATION_DECK,0,nil)
		if g1:GetCount()<1 or g2:GetCount()<1 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc2=g2:Select(tp,1,1,nil)
		tc1:Merge(tc2)
		Duel.SendtoGrave(tc1,REASON_EFFECT)
	else
		local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if tg:GetCount()>0 then
			Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
end
function c76859310.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c76859310.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c76859310.tfilter21(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859310.tfilter22(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(76859310)
end
function c76859310.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c76859310.tfilter21,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c76859310.tfilter22,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859310.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		return
	end
	local g1=Duel.GetMatchingGroup(c76859310.tfilter21,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c76859310.tfilter22,tp,LOCATION_DECK,0,nil)
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