--기어스트리트 트랜스포트
local m=52648007
local cm=_G["c"..m]
function cm.initial_effect(c)
   --Activate
   local e1=Effect.CreateEffect(c)
   e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
   e1:SetType(EFFECT_TYPE_ACTIVATE)
   e1:SetCode(EVENT_FREE_CHAIN)
   e1:SetCountLimit(1,m)
   e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e1:SetCost(cm.cost)
   e1:SetTarget(cm.target)
   e1:SetOperation(cm.activate)
   c:RegisterEffect(e1)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filter(c,tp)
   local otype=bit.band(c:GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
   local ctype=0x7-otype
   return c:IsFaceup() and ctype~=0 
	  and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,ctype)
end
function cm.thfilter(c,ctype)
   return c:IsAbleToHand() and c:IsType(ctype) and c:IsSetCard(0x5f8)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
   if chkc then return chkc:IsOnField() and cm.filter(chkc,tp) and chkc~=e:GetHandler() end
   if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),tp) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
   local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler(),tp)
   local otype=bit.band(g:GetFirst():GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
   local ctype=0x7-otype
   local dg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,ctype)
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
   local otype=bit.band(tc:GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
   local ctype=0x7-otype 
   local dg=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil,ctype)
   if dg:GetClassCount(Card.GetType)==0 then return end
   local g=Group.CreateGroup()
   for i=0,1 do
		if dg:GetClassCount(Card.GetType)==0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		return end
	  local tc=dg:Select(tp,1,1,nil):GetFirst()
	  g:AddCard(tc)
	  dg:Remove(Card.IsType,nil,bit.band(tc:GetType(),TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP))
   end
   Duel.SendtoHand(g,nil,REASON_EFFECT)
   Duel.ConfirmCards(1-tp,g)
end