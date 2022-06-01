--¸¶³àÀÇ ¿î¸í
local m=99000327
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,54360049)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(0)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.atktg)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
end
function cm.cfilter(c)
	return c:GetTextAttack()==-2 and c:IsAbleToRemoveAsCost()
end
function cm.thfilter(c,code1)
	return (c:GetTextAttack()==-2 or c:IsCode(54360049)) and c:IsAbleToHand() and not c:IsCode(code1)
end
function cm.costcheck(g,tp)
	local code1=g:GetFirst():GetCode()
	local tg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,code1)
	return tg:GetClassCount(Card.GetCode)>=2
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return g:CheckSubGroup(cm.costcheck,1,1,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,cm.costcheck,false,1,1,tp)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	sg:KeepAlive()
	e:SetLabelObject(sg)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local code1=g:GetFirst():GetCode()
	local tg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,code1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=tg:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if sg then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.atktg(e,c)
	return not (c:IsSetCard(0xc15) or c:IsCode(54360049)) 
end