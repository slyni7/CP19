--바벨의 도서관 장서 J.
local m=99970184
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Error.
	YuL.TheLibraryofBabel(c)

	--샐비지
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(YuL.LPcost(1200))
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
end

--샐비지
function cm.filter(c)
	return c:IsCode(99970171,99970172,99970173) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then return end
	local tg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,tg1:GetFirst():GetCode())
	local tg2=g:Select(tp,1,1,nil)
	tg1:Merge(tg2)
	if tg1:GetCount()==2 then
		Duel.SendtoHand(tg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg1)
	end
end
