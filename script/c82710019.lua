--더 머티리얼 로드
function c82710019.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c82710019.con1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(82710019,0))
	e2:SetCountLimit(1)
	e2:SetCost(c82710019.cost2)
	e2:SetTarget(c82710019.tar2)
	e2:SetOperation(c82710019.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
end
function c82710019.nfil1(c)
	return c:IsSetCard(0x5) and c:IsLevelBelow(4) and (c:IsFaceup() or c:IsLocation(LOCATON_GRAVE))
end
function c82710019.con1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c82710019.nfil1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c82710019.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c82710019.tfil21(c)
	return c:IsCode(82710020) and c:IsAbleToHand()
end
function c82710019.tfil22(c)
	return c:IsSetCard(0x5) and c:IsLevel(5,6) and c:IsAbleToHand()
end
function c82710019.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c82710019.tfil21,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(c82710019.tfil22,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c82710019.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g1=Duel.GetMatchingGroup(c82710019.tfil21,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c82710019.tfil22,tp,LOCATION_DECK,0,nil)
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