--Angel Notes - 피아니시모
function c76859102.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c76859102.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCost(c76859102.cost2)
	e2:SetTarget(c76859102.tg2)
	e2:SetOperation(c76859102.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e4:SetCost(c76859102.cost4)
	e4:SetCondition(c76859102.con4)
	e4:SetTarget(c76859102.tg4)
	e4:SetOperation(c76859102.op4)
	c:RegisterEffect(e4)
end
function c76859102.val1(e,te)
	return e:GetHandler()~=te:GetOwner() and te:IsActiveType(TYPE_MONSTER)
end
function c76859102.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetFlagEffect(tp,76859102)+Duel.GetFlagEffect(tp,76859152)<1
			or Duel.IsPlayerAffectedByEffect(tp,76859118)
	end
	Duel.RegisterFlagEffect(tp,76859102,RESET_PHASE+PHASE_END,0,1)
end
function c76859102.tfilter2(c)
	return c:IsSetCard(0x2c8) and c:IsSSetable() and not c:IsType(TYPE_FIELD)
end
function c76859102.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c76859102.tfilter2,tp,LOCATION_DECK,0,1,nil)
	end
end
function c76859102.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c76859102.tfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		local tc=g:GetFirst()
		Duel.SSet(tp,tc)
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
		end
	end
end
function c76859102.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (Duel.GetFlagEffect(tp,76859102)<1 or Duel.IsPlayerAffectedByEffect(tp,76859118))
			and Duel.GetFlagEffect(tp,76859152)<1
	end
	Duel.RegisterFlagEffect(tp,76859152,RESET_PHASE+PHASE_END,0,1)
end
function c76859102.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c76859102.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859102.ofilter41(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(76859102)
end
function c76859102.ofilter42(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER) and not c:IsCode(76859102)
end
function c76859102.op4(e,tp,eg,ep,ev,re,r,rp)
	local can=aux.AngelNotesCantabileOperation(e,tp,eg,ep,ev,re,r,rp)
	if can then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859102.ofilter41,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.IsExistingMatchingCard(c76859102.ofilter42,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if dg:GetCount()>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end