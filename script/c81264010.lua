--베노퀄리아 헤도라
--카드군 번호: 0xc94

function c81264010.initial_effect(c)
	
	c:EnableReviveLimit()
	
	--묘지 회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81264010)
	e1:SetCondition(c81264010.cn1)
	e1:SetTarget(c81264010.tg1)
	e1:SetOperation(c81264010.op1)
	c:RegisterEffect(e1)
	
	--효과 무효
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81264010,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,81264011)
	e2:SetCondition(c81264010.cn2)
	e2:SetTarget(c81264010.tg2)
	e2:SetOperation(c81264010.op2)
	c:RegisterEffect(e2)
	--프리체인
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c81264010.cn3)
	c:RegisterEffect(e3)
	
end

--묘지 회수
function c81264010.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_EFFECT)
end
function c81264010.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc94)
end
function c81264010.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81264010.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81264010.filter1,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81264010.filter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81264010.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--효과 무효
function c81264010.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>2
end
function c81264010.cn3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2
end

function c81264010.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c81264010.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ( ( tc:IsFaceup() and not tc:IsDisabled() ) or tc:IsType(TYPE_TRAPMONSTER) ) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:GetAttack()>0 and tc:IsLocation(LOCATION_MZONE) and Duel.SelectYesNo(tp,aux.Stringid(81264010,0)) then
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_ATTACK_FINAL)
			e4:SetValue(0)
			tc:RegisterEffect(e4)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e5=e1:Clone()
				e5:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				tc:RegisterEffect(e5)
			end
		end
	end
end
