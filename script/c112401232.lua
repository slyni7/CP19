--몽실몽실 곰돌이
function c112401232.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,112401232)
	e1:SetCondition(c112401232.spcon)
	e1:SetOperation(c112401232.spop)
	c:RegisterEffect(e1)
	--Tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112401232,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,112401232+100)
	e3:SetCondition(c112401232.spscon)
	e3:SetTarget(c112401232.spstg)
	e3:SetOperation(c112401232.spsop)
	c:RegisterEffect(e3)
end
function c112401232.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.CheckLPCost(c:GetControler(),800)
end
function c112401232.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,800)
end
function c112401232.spscon(e,tp,eg,ep,ev,re,r,rp)
	return re and e:GetHandler()~=re:GetOwner()
end
function c112401232.thfilter(c)
   return c:IsSetCard(0xfe1) and not c:IsCode(112401232) and c:IsAbleToHand()
end
function c112401232.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c112401232.thfilter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112401232.spsop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
   local g=Duel.SelectMatchingCard(tp,c112401232.thfilter,tp,LOCATION_DECK,0,1,1,nil)
   if g:GetCount()>0 then
	  Duel.SendtoHand(g,nil,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,g)
   end
end