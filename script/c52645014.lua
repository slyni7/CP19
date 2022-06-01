--멜로위버 레저넌스
local m=52645014
local cm=_G["c"..m]
function cm.initial_effect(c)
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,m)
    e1:SetTarget(cm.rmtg1)
    e1:SetOperation(cm.rmop1)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_REMOVE)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,m)
    e2:SetTarget(cm.rmtg2)
    e2:SetOperation(cm.rmop2)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
    e3:SetCategory(CATEGORY_REMOVE)
    e3:SetType(EFFECT_TYPE_ACTIVATE)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.rmtg3)
    e3:SetOperation(cm.rmop3)
    c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    e4:SetCondition(cm.handcon)
    c:RegisterEffect(e4)
end
function cm.hfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f5)
end
function cm.handcon(e)
    return Duel.IsExistingMatchingCard(cm.hfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.rmfilter(c)
    return c:IsSetCard(0x5f5) and c:IsAbleToRemove()
end
function cm.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.rmop1(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
    local tg=g:GetFirst()
    if tg==nil then return end
    Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
end
function cm.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,c) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD)
end
function cm.rmop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tc1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,1,c)
    if tc1 and Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		if tc2 then
			Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
		end
    end
end
function cm.rmtg3(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,c) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function cm.rmop3(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local tc1=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,1,1,c)
    if tc1 and Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,c) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc2=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,c)
		if tc2 then
			Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)
		end
    end
end