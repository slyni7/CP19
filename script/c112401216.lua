--LBH-유리베어
function c112401216.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xee5),2,2)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112401216,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,112401216)
	e1:SetCondition(c112401216.thcon)
	e1:SetTarget(c112401216.thtg)
	e1:SetOperation(c112401216.thop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112401216,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c112401216.thtg2)
	e2:SetOperation(c112401216.thop2)
	c:RegisterEffect(e2)
end
function c112401216.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c112401216.thfilter(c)
	return c:IsSetCard(0xee5) and c:IsAbleToHand()
end
function c112401216.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112401216.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112401216.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c112401216.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c112401216.tgfilter(c,tp,lg)
   return c:IsFaceup() and lg:IsContains(c) and Duel.IsExistingMatchingCard(c112401216.thfilter,tp,LOCATION_GRAVE,0,1,nil,c)
end
function c112401216.thfilter(c,tc)
   return c:IsAbleToHand() and c:IsSetCard(0xee5)
end
function c112401216.thtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   local c=e:GetHandler()
   local lg=c:GetLinkedGroup()
   if chkc then return chkc:IsLocation(LOCATION_MZONE) and c112401216.tgfilter(chkc,tp,lg) end
   if chk==0 then return Duel.IsExistingTarget(c112401216.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,lg) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
   Duel.SelectTarget(tp,c112401216.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,lg)
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c112401216.thop2(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
   if tc:IsRelateToEffect(e) then
	   Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
   end
   if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	  local g=Duel.SelectMatchingCard(tp,c112401216.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,tc)
	  if g:GetCount()>0 then
		 Duel.SendtoHand(g,tp,REASON_EFFECT)
		 Duel.ConfirmCards(1-tp,g)
	  end
   end
end