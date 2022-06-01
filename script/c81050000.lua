--야마메 hshs
--카드군 번호: 0xca6
function c81050000.initial_effect(c)
	
	--내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c81050000.imvl)
	c:RegisterEffect(e1)
	
	--어드밴스
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81050000,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x02)
	e2:SetCountLimit(1,81050000)
	e2:SetCondition(c81050000.smcn)
	e2:SetTarget(c81050000.smtg)
	e2:SetOperation(c81050000.smop)
	e2:SetHintTiming(0,0x1c0+TIMING_MAIN_END)
	c:RegisterEffect(e2)

	--회수
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81050000,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x10)
	e3:SetCountLimit(1,81050001)
	e3:SetCondition(c81050000.thcn)
	e3:SetCost(c81050000.thco)
	e3:SetTarget(c81050000.thtg)
	e3:SetOperation(c81050000.thop)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e3)
	
	--reduce
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1)
	e4:SetCondition(c81050000.rdcn)
	e4:SetOperation(c81050000.rdop)
	c:RegisterEffect(e4)
end

--immune
function c81050000.imvl(e,te)
	return te:IsActiveType(TYPE_TRAP)
	and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--sum.advance
function c81050000.smcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c81050000.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsSummonable(true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function c81050000.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSummonable(true,nil,1) then
		Duel.Summon(tp,c,true,nil,1)
	end
end

--to hand
function c81050000.thcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c81050000.thcofilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xca6)
end
function c81050000.thco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81050000.thcofilter,tp,LOCATION_GRAVE,0,2,c)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81050000.thcofilter,tp,LOCATION_GRAVE,0,2,2,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81050000.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c81050000.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end

--reduce
function c81050000.rdcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_ADVANCE
end

function c81050000.rdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		if tc:GetLevel()<tc:GetRank() then tlv=tc:GetRank() end
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-tlv*400)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Remove(dg,POS_FACEUP,REASON_EFFECT,true)
end
