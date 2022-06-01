--몽실몽실 유니콘
function c112401238.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112401238,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,112401238)
	e1:SetCondition(c112401238.spcon)
	e1:SetTarget(c112401238.sptg)
	e1:SetOperation(c112401238.spop)
	c:RegisterEffect(e1)
	--Tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(112401238,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c112401238.sscon)
	e2:SetTarget(c112401238.sstg)
	e2:SetOperation(c112401238.ssop)
	c:RegisterEffect(e2)
	--Tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112401238,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,112401238+100)
	e3:SetCondition(c112401238.spscon)
	e3:SetTarget(c112401238.spstg)
	e3:SetOperation(c112401238.spsop)
	c:RegisterEffect(e3)
end
function c112401238.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c112401238.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c112401238.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP)
end
function c112401238.sscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c112401238.filter(c)
	return c:IsSetCard(0xfe1) and not c:IsCode(112401238) and c:IsAbleToHand()
end
function c112401238.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c112401238.filter,tp,LOCATION_DECK,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c112401238.ssop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
   local g=Duel.SelectMatchingCard(tp,c112401238.filter,tp,LOCATION_DECK,0,1,1,nil)
   if g:GetCount()>0 then
	  Duel.SendtoHand(g,nil,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,g)
   end
   local e1=Effect.CreateEffect(e:GetHandler())
   e1:SetType(EFFECT_TYPE_FIELD)
   e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
   e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
   e1:SetTargetRange(1,0)
   e1:SetTarget(c112401238.splimit)
   e1:SetReset(RESET_PHASE+PHASE_END)
   Duel.RegisterEffect(e1,tp)
end
function c112401238.splimit(e,c)
   return not c:IsSetCard(0xfe1) or (c:IsAttackAbove(1) or c:IsDefenseAbove(1) or c:IsLevelAbove(2))
end
function c112401238.spscon(e,tp,eg,ep,ev,re,r,rp)
	return re and e:GetHandler()~=re:GetOwner()
end
function c112401238.thfilter(c)
   return c:IsSetCard(0xfe1) and not c:IsCode(112401238) and c:IsAbleToHand()
end
function c112401238.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c112401238.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
   Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c112401238.spsop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
   local g=Duel.SelectMatchingCard(tp,c112401238.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
   if g:GetCount()>0 then
	  Duel.SendtoHand(g,nil,REASON_EFFECT)
	  Duel.ConfirmCards(1-tp,g)
   end
end