--바위굴의 거미집
function c81050210.initial_effect(c)

	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c81050210.op2)
	c:RegisterEffect(e2)
	
	--summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c81050210.cn3)
	e3:SetTargetRange(1,1)
	e3:SetTarget(c81050210.lm3)
	c:RegisterEffect(e3)
	
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,81050210)
	e4:SetCondition(c81050210.cn4)
	e4:SetTarget(c81050210.tg4)
	e4:SetOperation(c81050210.op4)
	c:RegisterEffect(e4)
end

--activate
function c81050210.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckLPCost(tp,500) then
		Duel.PayLPCost(tp,500)
	else
		Duel.Destroy(e:GetHandler(),REASON_COST)
	end
end

--summon limit
function c81050210.filter1(c)
	return c:IsFaceup() and c:IsCode(81050000)
end
function c81050210.cn3(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():IsFaceup()
	and Duel.IsExistingMatchingCard(c81050210.filter1,tp,LOCATION_MZONE,0,1,nil)
	and not Duel.IsExistingMatchingCard(c81050210.filter1,tp,0,LOCATION_MZONE,1,nil)
end
function c81050210.lm3(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end

--search
function c81050210.cn4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c81050210.filter2(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca6) and c:IsType(TYPE_MONSTER)
	and c:IsLevelBelow(4)
end
function c81050210.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81050210.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c81050210.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81050210.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


