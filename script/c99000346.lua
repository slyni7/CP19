--이차원으로부터의 계약자
local m=99000346
local cm=_G["c"..m]
function cm.initial_effect(c)
	--order summon
	aux.AddOrderProcedure(c,"R",nil,cm.ordfilter1,cm.ordfilter2)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.stcost)
	e1:SetTarget(cm.sttg)
	e1:SetOperation(cm.stop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCountLimit(1,m+1000)
	e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)
end
cm.CardType_Order=true
function cm.ordfilter1(c)
	return not c:IsType(TYPE_TOKEN) and c:IsType(TYPE_MONSTER)
end
function cm.ordfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.filter(c)
	return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSSetable()
end
function cm.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.stop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SSet(tp,tc)~=0 then
		tc:RegisterFlagEffect(99000346,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
		--activate
		local ea=Effect.CreateEffect(e:GetHandler())
		ea:SetType(EFFECT_TYPE_FIELD)
		ea:SetCode(EFFECT_ACTIVATE_COST)
		ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
		ea:SetTargetRange(1,1)
		ea:SetTarget(cm.tar0)
		ea:SetOperation(cm.op0)
		Duel.RegisterEffect(ea,0)
	end
end
function cm.tar0(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_SZONE) and tc:GetFlagEffect(99000346)>0
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local eb=Effect.CreateEffect(e:GetHandler())
	eb:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	eb:SetRange(LOCATION_SZONE)
	eb:SetCode(EVENT_PHASE+PHASE_END)
	eb:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	eb:SetOperation(cm.setrmop)
	eb:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END-RESET_TURN_SET)
	eb:SetCountLimit(1)
	tc:RegisterEffect(eb)
end
function cm.setrmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,99000346)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return Duel.GetAttacker()==c and bc and bc:IsControler(1-tp)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return bc and bc:IsRelateToBattle() and bc:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,bc,1,0,0)
	Duel.RegisterFlagEffect(tp,99000346+1000,RESET_PHASE+PHASE_END,0,1)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetLabelObject()
	if bc and bc:IsRelateToBattle() and bc:IsControler(1-tp) and Duel.Remove(bc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		bc:SetTurnCounter(0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		e1:SetLabelObject(bc)
		e1:SetCountLimit(1)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	ct=ct+1
	tc:SetTurnCounter(ct)
	if ct==2 then
		Duel.ReturnToField(tc)
	end
end