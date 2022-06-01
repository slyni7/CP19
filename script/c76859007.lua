--고스토피아 스팀
function c76859007.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(c76859007.con1)
	e1:SetOperation(c76859007.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCountLimit(1)
	e2:SetCondition(c76859007.con2)
	e2:SetOperation(c76859007.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetCondition(c76859007.con3)
	e3:SetTarget(c76859007.tg3)
	e3:SetOperation(c76859007.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,76859007)
	e4:SetCondition(c76859007.con4)
	e4:SetOperation(c76859007.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetTarget(c76859007.tg5)
	e5:SetOperation(c76859007.op5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e6)
end
function c76859007.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c76859007.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(76859007)>0 then
		local ct=c:GetTurnCounter()
		c:SetTurnCounter(ct+1)
	else
		c:RegisterFlagEffect(76859007,RESET_EVENT+0x1fe0000,0,0)
		c:SetTurnCounter(1)
	end
end
function c76859007.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==tp and c:GetFlagEffect(76859007)<1
end
function c76859007.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(76859007,RESET_EVENT+0x1fe0000,0,0)
	c:SetTurnCounter(1)
end
function c76859007.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	return c:GetFlagEffect(76859007)>0 and ct==2 and Duel.GetTurnPlayer()==tp
end
function c76859007.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,4)
end
function c76859007.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.DiscardDeck(tp,4,REASON_EFFECT)
end
function c76859007.nfil4(c)
	return c:IsSetCard(0x2cc) and c:IsAbleToGraveAsCost() and not c:IsCode(76859007)
end
function c76859007.con4(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c76859007.nfil4,tp,LOCATION_MZONE,0,1,nil)
end
function c76859007.op4(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76859007.nfil4,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c76859007.ofil5(c)
	return c:IsSetCard(0x2cc) and c:IsAbleToGrave() and not c:IsCode(76859007)
end
function c76859007.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c76859007.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c76859007.ofil5,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end