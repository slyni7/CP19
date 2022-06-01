--[ Fake Spirit ]
local m=99970780
local cm=_G["c"..m]
function cm.initial_effect(c)

	YuL.Activate(c)
	
	--패 발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.con0)
	c:RegisterEffect(e0)
	
	--봉인
	local e3=MakeEff(c,"Qo","S")
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCL(1)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	
	--대상 내성
	local e2=MakeEff(c,"S","S")
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCondition(cm.con2)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--회수
	local e1=MakeEff(c,"Qo","G")
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCL(1)
	e1:SetCondition(YuL.turn(0))
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)

end

--패 발동
function cm.countfil(c)
	return c:IsFaceup() and c:IsSetCard(0x6d6d)
end
function cm.con0(e)
	local g=Duel.GetMatchingGroup(cm.countfil,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end

--봉인
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.countfil,tp,LOCATION_ONFIELD,0,nil)
	return ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
		and g:GetClassCount(Card.GetCode)>=6
end
function cm.cost3fil(c)
	return c:IsSetCard(0x6d6d) and c:IsDiscardable()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cost3fil,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,cm.cost3fil,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,re:GetHandler():GetLocation())
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,re:GetHandler():GetPreviousLocation())
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(cm.aclimit)
		e1:SetLabel(re:GetHandler():GetCode())
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(e:GetLabel())
end

--대상 내성
function cm.con2(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsCode,m-9),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

--회수
function cm.cost1fil(c)
	return c:IsSetCard(0x6d6d) and c:IsAbleToRemoveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cost1fil,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cost1fil,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
