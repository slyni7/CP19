--베노퀄리아 소피스트라
--카드군 번호: 0xc94

function c81264040.initial_effect(c)

	c:EnableReviveLimit()
	
	--묘지 회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81264040)
	e1:SetCondition(c81264040.cn1)
	e1:SetTarget(c81264040.tg1)
	e1:SetOperation(c81264040.op1)
	c:RegisterEffect(e1)
	
	--파괴 회피
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c81264040.tg2)
	c:RegisterEffect(e2)
	
	--발동 무효
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81264041)
	e3:SetCondition(c81264040.cn3)
	e3:SetTarget(c81264040.tg3)
	e3:SetOperation(c81264040.op3)
	c:RegisterEffect(e3)
end

--묘지 회수
function c81264040.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
	and e:GetHandler():IsReason(REASON_EFFECT)
end
function c81264040.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc94)
end
function c81264040.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81264040.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81264040.filter1,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81264040.filter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81264040.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--파괴 회피
function c81264040.filter2(c)
	return c:IsAbleToGrave() and c:IsRace(RACE_REPTILE)
end
function c81264040.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_BATTLE)
		and Duel.IsExistingMatchingCard(c81264040.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c81264040.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST)
		return true
	else return false end
end

--발동 무효
function c81264040.cn3(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
	and ep~=tp and Duel.IsChainNegatable(ev)
end
function c81264040.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c81264040.filter4(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c81264040.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if Duel.SelectYesNo(tp,aux.Stringid(81264040,0)) then
	local tc=1
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then tc=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c81264040.filter4,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc,nil)
	local tc=g:GetFirst()
	Duel.BreakEffect()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
		end
	end
end
