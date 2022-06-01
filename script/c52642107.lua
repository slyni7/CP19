--신식의 준비
local m=52642107
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.tftg)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(52642107)
    e2:SetRange(LOCATION_FZONE)
    e2:SetTargetRange(1,0)
    c:RegisterEffect(e2)
end
function cm.tffilter(c,tp)
    return c:IsCode(72710085) and not c:IsForbidden()
end
function cm.filter2(c)
    return c:IsDiscardable()
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	if Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
        Duel.DiscardHand(tp,cm.filter2,1,1,REASON_EFFECT+REASON_DISCARD)
		e:SetOperation(cm.activate)
		else
		e:SetOperation(nil)
		end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end