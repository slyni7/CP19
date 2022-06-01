--수배의 시련(수부, 귀정)
--카드군 번호: 0xc8c
local m=81237050
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--효과 무효
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

--효과를 받지 않는다
function cm.filter1(c)
	return c:IsFaceup() and c:IsCode(81237000)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter1,tp,0x0c+0x10,0,1,nil)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetChainLimit(aux.FALSE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.filter1,tp,0x0c+0x10,0,1,nil) then
		return
	end
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x02,nil)
		if #g>0 and	Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(0x04,0)
	e1:SetTarget(cm.o1tg1)
	e1:SetValue(cm.o1va1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.o1tg1(e,c)
	return c:IsFaceup() and (c:IsRace(RACE_BEAST) or c:IsRace(RACE_BEASTWARRIOR) or c:IsRace(RACE_WINDBEAST))
end
function cm.o1va1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--효과 무효
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated()
	and (re:GetHandler():IsSetCard(0xc8c) or re:GetHandler():IsCode(81237000))
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,0x0c,1,nil)
	end
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,0x0c,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,0x0c,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
