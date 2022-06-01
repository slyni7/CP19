--고스토피아 에반
function c76859009.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),3,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(c76859009.con1)
	e1:SetOperation(c76859009.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCountLimit(1)
	e2:SetCondition(c76859009.con2)
	e2:SetOperation(c76859009.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetCondition(c76859009.con3)
	e3:SetTarget(c76859009.tg3)
	e3:SetOperation(c76859009.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c76859009.val4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetValue(9999)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_ATTACK_COST)
	e7:SetCost(c76859009.cost7)
	e7:SetOperation(c76859009.op7)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_BATTLE_DESTROYING)
	e8:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetTarget(c76859009.tg8)
	e8:SetOperation(c76859009.op8)
	c:RegisterEffect(e8)
end
function c76859009.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c76859009.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(76859009)>0 then
		local ct=c:GetTurnCounter()
		c:SetTurnCounter(ct+1)
	else
		c:RegisterFlagEffect(76859009,RESET_EVENT+0x1fe0000,0,0)
		c:SetTurnCounter(1)
	end
end
function c76859009.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==tp and c:GetFlagEffect(76859009)<1
end
function c76859009.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(76859009,RESET_EVENT+0x1fe0000,0,0)
	c:SetTurnCounter(1)
end
function c76859009.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	return c:GetFlagEffect(76859009)>0 and ct==2 and Duel.GetTurnPlayer()==tp
end
function c76859009.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c76859009.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.ConfirmDecktop(tp,6)
	local g=Duel.GetDecktopGroup(tp,6)
	local sg=g:Filter(Card.IsSetCard,nil,0x2f9)
	Duel.SendtoGrave(sg,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end
function c76859009.vfil4(c)
	return c:IsFaceup() and not c:IsCode(76859009)
end
function c76859009.val4(e,c)
	local g=Duel.GetMatchingGroup(c76859009.vfil4,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()<1 then
		return 0
	else
		local tg,val=g:GetMaxGroup(Card.GetAttack)
		return val*2
	end
end
function c76859009.cost7(e,c,tp)
	local c0=e:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,c0) or c0:GetAttackAnnouncedCount()<1
end
function c76859009.op7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetAttackAnnouncedCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c76859009.tg8(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859009.ofil8(c)
	return c:IsSetCard(0x2cc) and c:IsAbleToHand()
end
function c76859009.op8(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859009.ofil8,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end