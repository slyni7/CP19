--파이널 히어로 리틀 도브
function c17290002.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetValue(c17290002.val4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetCountLimit(1,17290002)
	e5:SetCost(c17290002.cost5)
	e5:SetTarget(c17290002.tg5)
	e5:SetOperation(c17290002.op5)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e6:SetCountLimit(1,172900020)
	e6:SetCondition(c17290002.con6)
	e6:SetTarget(c17290002.tg6)
	e6:SetOperation(c17290002.op6)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
end
function c17290002.mat_filter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) or c:IsSetCard(0x8)
end
function c17290002.val4(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c17290002.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c17290002.tfilter5(c)
	return c:IsSetCard(0x2c3) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c17290002.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c17290002.tfilter5,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c17290002.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c17290002.tfilter5,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c17290002.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetCode()==EVENT_SPSUMMON_SUCCESS then
		return c:GetSummonType()==SUMMON_TYPE_RITUAL
	end
	return true
end
function c17290002.tfilter6(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and ((c:IsSetCard(0x2c3) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL))
			or (c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER))) and c:IsAbleToHand() and not c:IsCode(17290002)
end
function c17290002.tg6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c17290002.tfilter6(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c17290002.tfilter6,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c17290002.tfilter6,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function c17290002.ofilter6(c)
	return ((c:IsSetCard(0x2c3) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL))
			or (c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER))) and c:IsAbleToGrave()
end
function c17290002.op6(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT) then
		Duel.ConfirmCards(1-tp,sg)
		local dg=Duel.GetMatchingGroup(c17290002.ofilter6,tp,LOCATION_DECK,0,nil)
		if dg:GetClassCount(Card.GetCode)>3
			and Duel.SelectYesNo(tp,aux.Stringid(17290002,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local dg1=dg:Select(tp,1,1,nil)
			dg:Remove(Card.IsCode,nil,dg1:GetFirst():GetCode())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local dg2=dg:Select(tp,1,1,nil)
			dg:Remove(Card.IsCode,nil,dg2:GetFirst():GetCode())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local dg3=dg:Select(tp,1,1,nil)
			dg:Remove(Card.IsCode,nil,dg3:GetFirst():GetCode())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local dg4=dg:Select(tp,1,1,nil)
			dg1:Merge(dg2)
			dg1:Merge(dg3)
			dg1:Merge(dg4)
			Duel.SendtoGrave(dg1,REASON_EFFECT)
		end
	end
end