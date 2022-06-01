--몽실몽실하지 않은건 싫어
local m=112401250
local cm=_G["c"..m]
function c112401250.initial_effect(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.acost)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(cm.disable1)
	e3:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetTargetRange(0,LOCATION_ONFIELD)
	e4:SetTarget(cm.disable2)
	c:RegisterEffect(e4)
	--Activate in the opponent's turn
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_DECK)
	e5:SetCost(cm.acost)
	e5:SetTarget(cm.actg)
	e5:SetOperation(cm.acop)
	c:RegisterEffect(e5)
end
function cm.cffilter(c)
	return not c:IsCode(112401250) and c:IsSetCard(0xfe1) and not c:IsPublic()
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.RaiseEvent(c,EVENT_CHAIN_SOLVED,c:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.acost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	if e:IsHasType(EFFECT_TYPE_QUICK_O) then
		Duel.SetChainLimit(aux.FALSE)
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.disable1(e,c)
	return not c:IsSetCard(0xfe1) and ((c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT) or (c:IsType(TYPE_SPELL) or (c:GetOriginalType()&TYPE_SPELL)==TYPE_SPELL) or (c:IsType(TYPE_TRAP) or (c:GetOriginalType()&TYPE_TRAP)==TYPE_TRAP))
end
function cm.disable2(e,c)
	return not c:IsOriginalSetCard(0xfe1) and ((c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT) or (c:IsType(TYPE_SPELL) or (c:GetOriginalType()&TYPE_SPELL)==TYPE_SPELL) or (c:IsType(TYPE_TRAP) or (c:GetOriginalType()&TYPE_TRAP)==TYPE_TRAP))
end