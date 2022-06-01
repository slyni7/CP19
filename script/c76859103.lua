--Angel Notes - 나이트코어
function c76859103.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c76859103.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_NEGATE+CATEGORY_RECOVER)
	e2:SetCost(c76859103.cost2)
	e2:SetCondition(c76859103.con2)
	e2:SetTarget(c76859103.tg2)
	e2:SetOperation(c76859103.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e3:SetCost(c76859103.cost3)
	e3:SetCondition(c76859103.con3)
	e3:SetTarget(c76859103.tg3)
	e3:SetOperation(c76859103.op3)
	c:RegisterEffect(e3)
end
function c76859103.val1(e,te)
	return e:GetHandler()~=te:GetOwner() and te:IsActiveType(TYPE_MONSTER)
end
function c76859103.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (Duel.GetFlagEffect(tp,76859103)+Duel.GetFlagEffect(tp,76859153)<1
			or Duel.IsPlayerAffectedByEffect(tp,76859118))
			and Duel.IsExistingMatchingCard(c76859103.cfilter2,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.RegisterFlagEffect(tp,76859103,RESET_PHASE+PHASE_END,0,1)
	Duel.DiscardHand(tp,c76859103.cfilter2,1,1,REASON_COST+REASON_DISCARD)
end
function c76859103.con2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c76859103.cfilter2(c)
	return c:IsSetCard(0x2c8) and c:IsDiscardable()
end
function c76859103.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c76859103.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local rc=re:GetHandler()
	local atk=rc:GetAttack()/2
	if rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if atk>0 then
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end
function c76859103.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (Duel.GetFlagEffect(tp,76859103)<1 or Duel.IsPlayerAffectedByEffect(tp,76859118))
			and Duel.GetFlagEffect(tp,76859153)<1
	end
	Duel.RegisterFlagEffect(tp,76859153,RESET_PHASE+PHASE_END,0,1)
end
function c76859103.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c76859103.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859103.ofilter31(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(76859103)
end
function c76859103.ofilter32(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER) and not c:IsCode(76859103)
end
function c76859103.op3(e,tp,eg,ep,ev,re,r,rp)
	local can=aux.AngelNotesCantabileOperation(e,tp,eg,ep,ev,re,r,rp)
	if can then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859103.ofilter31,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.IsExistingMatchingCard(c76859103.ofilter32,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if dg:GetCount()>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end