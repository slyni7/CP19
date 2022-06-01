--바벨의 도서관 장서 L.
local m=99970186
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Error.
	YuL.TheLibraryofBabel(c)

	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATRGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(spinel.drawtg(0,1))
	e1:SetOperation(spinel.drawop)
	c:RegisterEffect(e1)
	
end

--드로우
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(99970172) and c:IsAbleToHandAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
