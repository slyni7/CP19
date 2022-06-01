--견도의 시련(광부, 귀정)
--카드군 번호: 0xc8c
local m=81237060
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
	
	--회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
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

--효과를 발동할 수 없으며, 무효화된다
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
function cm.filter2(c)
	return c:IsAbleToRemove() and c:IsType(0x2+0x4)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.filter1,tp,0x0c+0x10,0,1,nil) then
		return
	end
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(cm.filter2,tp,0,0x02+0x0c,nil)
		if #g>1 and	Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg=g:Select(1-tp,2,2,nil)
			Duel.ConfirmCards(tp,sg)
			Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.o1va1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local og=Duel.GetMatchingGroup(cm.disfilter1,tp,0,0x04+0x10,nil,e)
	local tc=og:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e3)
		tc=og:GetNext()
	end	
end
function cm.disfilter1(c)
	return c:IsFaceup() and not c:IsDisabled() and (not c:IsType(TYPE_NORMAL) or c:GetOriginalType()&TYPE_EFFECT~=0)
	and c:IsType(0x1)
end
function cm.o1va1(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(0x1) and (c:IsLocation(0x04) or c:IsLocation(0x10))
end

--샐비지
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated()
	and (re:GetHandler():IsSetCard(0xc8c) or re:GetHandler():IsCode(81237000))
end
function cm.tfil0(c)
	return (c:IsFaceup() or c:IsLocation(0x10)) and c:IsAbleToHand() and c:IsSetCard(0xc8c)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x10+0x20,0,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10+0x20)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tfil0),tp,0x10+0x20,0,e:GetHandler())
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
	if sg and #sg>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
