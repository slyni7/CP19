--더 스피리추얼 로드
function c82710020.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c82710020.con1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetDescription(aux.Stringid(82710020,0))
	e2:SetCountLimit(1)
	e2:SetCost(c82710020.cost2)
	e2:SetTarget(c82710020.tar2)
	e2:SetOperation(c82710020.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e3)
end
function c82710020.nfil1(c)
	return c:IsSetCard(0x5) and c:IsLevel(5,6) and (c:IsFaceup() or c:IsLocation(LOCATON_GRAVE))
end
function c82710020.con1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(c82710020.nfil1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c82710020.cfil2(c)
	return c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c82710020.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c82710020.cfil2,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c82710020.cfil2,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c82710020.tfil2(c)
	return c:IsCode(82710018) and c:IsAbleToHand()
end
function c82710020.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c82710020.tfil2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c82710020.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c82710020.tfil2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end