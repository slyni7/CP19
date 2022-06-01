--Angel Notes - Ã¼¸®¹ÎÆ®
function c76859108.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c76859108.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76859108,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetCost(c76859108.cost2)
	e2:SetTarget(c76859108.tg2)
	e2:SetOperation(c76859108.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(76859108,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e3:SetCost(c76859108.cost3)
	e3:SetCondition(c76859108.con3)
	e3:SetTarget(c76859108.tg3)
	e3:SetOperation(c76859108.op3)
	c:RegisterEffect(e3)
end
function c76859108.val1(e,te)
	return e:GetHandler()~=te:GetOwner() and te:IsActiveType(TYPE_MONSTER)
end
function c76859108.cfilter2(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c76859108.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return (Duel.GetFlagEffect(tp,76859108)+Duel.GetFlagEffect(tp,76859158)<1
			or Duel.IsPlayerAffectedByEffect(tp,76859118))
			and Duel.IsExistingMatchingCard(c76859108.cfilter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.RegisterFlagEffect(tp,76859108,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c76859108.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c76859108.tfilter2(c)
	return c:IsDestructable() and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c76859108.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c76859108.tfilter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c76859108.tfilter2,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c76859108.tfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c76859108.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()/2
		Duel.Destroy(tc,REASON_EFFECT)
		if atk>0 then
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end
function c76859108.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (Duel.GetFlagEffect(tp,76859108)<1 or Duel.IsPlayerAffectedByEffect(tp,76859118))
			and Duel.GetFlagEffect(tp,76859158)<1
	end
	Duel.RegisterFlagEffect(tp,76859158,RESET_PHASE+PHASE_END,0,1)
end
function c76859108.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c76859108.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859108.ofilter31(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(76859108)
end
function c76859108.ofilter32(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_MONSTER) and not c:IsCode(76859108)
end
function c76859108.op3(e,tp,eg,ep,ev,re,r,rp)
	local can=aux.AngelNotesCantabileOperation(e,tp,eg,ep,ev,re,r,rp)
	if can then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859108.ofilter31,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.IsExistingMatchingCard(c76859108.ofilter32,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if dg:GetCount()>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end