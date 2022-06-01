--폭부 픽스트 스타
--카드군 번호: 0xca4
function c81040240.initial_effect(c)

	--서치
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,81040241)
	e0:SetCost(aux.bfgcost)
	e0:SetTarget(c81040240.tg0)
	e0:SetOperation(c81040240.op0)
	c:RegisterEffect(e0)
	
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,81040240)
	e1:SetCondition(c81040240.cn1)
	e1:SetTarget(c81040240.tg1)
	e1:SetOperation(c81040240.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c81040240.cn2)
	c:RegisterEffect(e2)
	if not c81040240.global_check then
		c81040240.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c81040240.gop1)
		Duel.RegisterEffect(ge1,0)
	end
end

--서치
function c81040240.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca4) and c:IsLevelBelow(4) and c:IsType(TYPE_MONSTER)
end
function c81040240.tg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81040240.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c81040240.op0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81040240.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		local tc=g:GetFirst()
		Duel.Damage(tp,tc:GetLevel()*100,REASON_EFFECT)
	end
end

--패에서 발동
function c81040240.gop1(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)>=1200 then
		Duel.RegisterFlagEffect(ep,81040240,RESET_PHASE+PHASE_END,0,1)
	end
end
function c81040240.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,81040240)~=0
end

--효과 처리
function c81040240.cn1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		return false
	end
	return Duel.IsChainNegatable(ev) and ( re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE) )
end
function c81040240.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xca4)
end
function c81040240.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(c81040240.filter1,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81040240.filter1,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1200)
	end
end
function c81040240.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		local tc=Duel.GetFirstTarget()
		Duel.BreakEffect()
		if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Recover(tp,1200,REASON_EFFECT)
		end
	end
end
