--[ Fake Spirit ]
local m=99970777
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(cm.tar0)
	c:RegisterEffect(e0)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	
	--파괴
	local e1=MakeEff(c,"Qo","S")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCL(1)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)

	--파괴 대행
	local e4=MakeEff(c,"SC","S")
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetTarget(cm.tar4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	
end

--발동
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	local e1=Effect.CreateEffect(c)
	e1:SetD(m,1)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(1082946)
	e3:SetLabelObject(e1)
	e3:SetOwnerPlayer(tp)
	e3:SetOperation(cm.reset)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	c:RegisterEffect(e3)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm.desop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
		if re then re:Reset() end
	end
end

--파괴
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tar1fil,tp,LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
function cm.tar1fil(c)
	return c:IsFaceup() and c:IsSetCard(0x6d6d)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.tar1fil,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.tar1fil,tp,LOCATION_ONFIELD,0,1,1,nil)
	local cg=g:GetFirst():GetColumnGroup()
	cg:AddCard(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,cg,#cg,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local cg=tc:GetColumnGroup()
	cg:AddCard(tc)
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(cg,REASON_EFFECT)
	end
end

--파괴 대행
function cm.tar4fil(c)
	return c:IsSetCard(0x6d6d) and c:IsAbleToDeck()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_RULE)
		and Duel.IsExistingMatchingCard(cm.tar4fil,tp,LOCATION_GRAVE,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tar4fil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end