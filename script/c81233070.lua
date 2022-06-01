--황혼의 일격
--카드군 번호: 0xc70
local m=81233070
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공통 트리거
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(0x10)
	e1:SetCountLimit(1,m)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--발동 무효
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.cn3)
	c:RegisterEffect(e3)
end

--효과 무효
function cm.tfilter1(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsControler(tp) and cm.tfilter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfilter1,tp,0x04,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.tfilter1,tp,0x04,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_SOLVING)
		e1:SetCondition(cm.op1n)
		e1:SetOperation(cm.op1o)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.op1n(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local tlv=tc:GetLevel()
	return rp==1-tp and Duel.IsChainNegatable(ev) and re:GetHandler():GetLevel()<tlv and re:IsActiveType(0x1)
end
function cm.op1o(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)==0 then
		if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.NegateEffect(ev)
		end
		Duel.RegisterFlagEffect(tp,m.RESET_PHASE+PHASE_END,0,1)
	end
end

--발동 무효
function cm.nfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0xc8f)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.nfilter2,tp,0x04,0,1,nil) then
		return false
	end
	if not Duel.IsChainNegatable(ev) then
		return false
	end
	return rp==1-tp	and ( re:IsActiveType(0x1) or re:IsHasType(EFFECT_TYPE_ACTIVATE) )
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(e) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.nfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc8f) and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(8)
end
function cm.cn3(e)
	return Duel.IsExistingMatchingCard(cm.nfilter1,e:GetHandlerPlayer(),0x04,0,1,nil)
end
