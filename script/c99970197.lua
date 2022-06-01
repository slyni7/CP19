--바벨의 도서관 장서 W.
local m=99970197
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Error.
	YuL.TheLibraryofBabel(c)

	--회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	
	--El Aleph
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(aux.exccon)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	
end

--회수
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	end
end

--El Aleph
function cm.cfilter(c,tp)
	return c:IsSetCard(0xd39) and c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,2,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,2,2,nil,tp)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,99970173)
	Duel.SendtoHand(token,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,token)
end
