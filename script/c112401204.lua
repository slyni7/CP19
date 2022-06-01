--BH-루나틱래빗
function c112401204.initial_effect(c)
   --tohand
   local e1=Effect.CreateEffect(c)
   e1:SetDescription(aux.Stringid(26674724,0))
   e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   e1:SetType(EFFECT_TYPE_IGNITION)
   e1:SetRange(LOCATION_HAND)
   e1:SetCountLimit(1,1112401204)
   e1:SetCost(c112401204.thcost)
   e1:SetTarget(c112401204.thtg)
   e1:SetOperation(c112401204.thop)
   c:RegisterEffect(e1)
end
function c112401204.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return e:GetHandler():IsDiscardable() end
   Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c112401204.thfilter(c)
   return (c:IsSetCard(0xee6) or c:IsCode(24094653)) and c:IsAbleToHand()
end
function c112401204.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c112401204.thfilter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112401204.thop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
   local g=Duel.SelectMatchingCard(tp,c112401204.thfilter,tp,LOCATION_DECK,0,1,1,nil)
   if g:GetCount()>0 then
	  Duel.SendtoHand(g,nil,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,g)
   end
end