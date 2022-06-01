--Angel Notes - 크레센도
function c76859113.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2c8),nil,1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c76859113.val1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetDescription(aux.Stringid(76859113,0))
	e2:SetCondition(c76859113.con2)
	e2:SetCost(c76859113.cost2)
	e2:SetTarget(c76859113.tg2)
	e2:SetOperation(c76859113.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetDescription(aux.Stringid(76859113,0))
	e3:SetCost(c76859113.cost2)
	e3:SetTarget(c76859113.tg3)
	e3:SetOperation(c76859113.op2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(76859113,1))
	e4:SetCost(c76859113.cost4)
	e4:SetCondition(c76859113.con4)
	e4:SetTarget(c76859113.tg4)
	e4:SetOperation(c76859113.op4)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x2c8))
	e5:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_RECOVER)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c76859113.con7)
	e7:SetOperation(c76859113.op7)
	c:RegisterEffect(e7)
end
function c76859113.val1(e,te)
	return e:GetHandler()~=te:GetOwner() and te:IsActiveType(TYPE_MONSTER)
end
function c76859113.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.CheckEvent(EVENT_CHAINING)
end
function c76859113.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(1)
	if chk==0 then
		return Duel.GetFlagEffect(tp,76859113)+Duel.GetFlagEffect(tp,76859163)<1
			or Duel.IsPlayerAffectedByEffect(tp,76859118)
	end
	Duel.RegisterFlagEffect(tp,76859113,RESET_PHASE+PHASE_END,0,1)
end
function c76859113.tfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2c8) and c:IsAbleToDeckAsCost()
		and c:CheckActivateEffect(false,true,false)~=nil
end
function c76859113.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then
			return false
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c76859113.tfilter2,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c76859113.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c76859113.op2(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then
		return
	end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then
		op(e,tp,eg,ep,ev,re,r,rp)
	end
end
function c76859113.tfilter3(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x2c8) and c:IsAbleToDeckAsCost() then
		if c:CheckActivateEffect(false,true,false)~=nil then
			return true
		end
		local te=c:GetActivateEffect()
		if te:GetCode()~=EVENT_CHAINING then
			return false
		end
		local con=te:GetCondition()
		if con and not con(e,tp,eg,ep,ev,re,r,rp) then
			return false
		end
		local tg=te:GetTarget()
		if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then
			return false
		end
		return true
	else
		return false
	end
end
function c76859113.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then
			return false
		end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c76859113.tfilter3,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c76859113.tfilter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local tc=g:GetFirst()
	local te,ceg,cep,cev,cre,cr,crp
	local fchain=c76859113.tfilter2(tc)
	if fchain then
		te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
	else
		te=tc:GetActivateEffect()
	end
	Duel.HintSelection(g)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then
		if fchain then
			tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
		else
			tg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c76859113.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return (Duel.GetFlagEffect(tp,76859113)<1 or Duel.IsPlayerAffectedByEffect(tp,76859118))
			and Duel.GetFlagEffect(tp,76859163)<1
	end
	Duel.RegisterFlagEffect(tp,76859163,RESET_PHASE+PHASE_END,0,1)
end
function c76859113.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c76859113.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859113.ofilter41(c)
	return c:IsSetCard(0x2c8) and c:IsAbleToHand()
end
function c76859113.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859113.ofilter41,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x2c8) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if dg:GetCount()>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
function c76859113.con7(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c76859113.op7(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,76859113)
	Duel.Damage(1-tp,ev,REASON_EFFECT)
end