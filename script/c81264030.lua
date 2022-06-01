--베노퀄리아 레비안테
--카드군 번호: 0xc94

function c81264030.initial_effect(c)

	c:EnableReviveLimit()
	
	--묘지 회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81264030)
	e1:SetCondition(c81264030.cn1)
	e1:SetTarget(c81264030.tg1)
	e1:SetOperation(c81264030.op1)
	c:RegisterEffect(e1)
	
	--유발 효과
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81264031)
	e2:SetCondition(c81264030.cn2)
	e2:SetTarget(c81264030.tg2)
	e2:SetOperation(c81264030.op2)
	c:RegisterEffect(e2)
	
	--지속 효과
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c81264030.cn3)
	e3:SetOperation(c81264030.op3)
	c:RegisterEffect(e3)
end

--묘지 회수
function c81264030.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
	and e:GetHandler():IsReason(REASON_EFFECT)
end
function c81264030.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc94)
end
function c81264030.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81264030.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81264030.filter1,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81264030.filter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81264030.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--유발 효과
function c81264030.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c81264030.filter2(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:GetAttack()>0
end
function c81264030.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81264030.filter2,tp,0,LOCATION_MZONE,1,nil)
	end
end
function c81264030.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81264030.filter2,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then
		return
	end
	local tc=g:GetFirst()
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

--지속 효과
function c81264030.cn3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetAttack()==0
	and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2
end
function c81264030.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
