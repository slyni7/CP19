--BH-뉴마우스
local m=112401221
local cm=_G["c"..m]
function c112401221.initial_effect(c)
   --tohand
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(26674724,0))
   e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetRange(LOCATION_HAND)
   e1:SetCountLimit(1,1112401221)
   e1:SetCost(cm.thcost)
   e1:SetTarget(cm.thtg)
   e1:SetOperation(cm.thop)
   c:RegisterEffect(e1)
   local e4=Effect.CreateEffect(c)
   e4:SetDescription(aux.Stringid(112401201,0))
   e4:SetCategory(CATEGORY_TOHAND)
   e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
   e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
   e4:SetCode(EVENT_BE_MATERIAL)
   e4:SetCountLimit(1,1112401221+100)
   e4:SetCondition(cm.condition)
   e4:SetTarget(cm.thtg2)
   e4:SetOperation(cm.thop2)
   c:RegisterEffect(e4)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsDiscardable() end
   Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c)
   return (c:IsSetCard(0xee5) and not c:IsCode(112401221)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
   local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
   if g:GetCount()>0 then
	  Duel.SendtoHand(g,nil,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,g)
   end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION
end
function cm.thfilter2(c)
	return c:IsSetCard(0xee5) and not c:IsCode(112401221) and c:IsAbleToHand()
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end