--비통일마법세계론 (몽시공)
--카드군 번호: 0xc97
local m=81261100
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetRange(0x10)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--발동
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and (re:IsActiveType(0x1) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function cm.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc97)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x02+0x10,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x02+0x10,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_ORDER) and c:IsAttribute(0x04)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=1
	if Duel.IsExistingMatchingCard(cm.filter1,tp,0x04,0,1,nil) then ct=ct+1 end
	if chkc then
		return chkc:IsOnField() and aux.disfilter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.disfilter1,tp,0x0c,0x0c,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0x0c,0x0c,1,ct,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	for tc in aux.Next(tg) do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetTargetRange(0,1)
	e3:SetValue(cm.o1va3)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.o1va3(e,re,val,r,rp,rc)
	return math.floor(val/2)
end

--서치
function cm.filter2(c,tp)
	return c:IsType(TYPE_ORDER) and c:IsAttribute(0x04) and c:IsFaceup() and c:IsControler(tp)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter2,1,nil,tp)
end
function cm.cfil1(c)
	return c:IsAbleToRemoveAsCost() and c:GetType()==0x10002
end
function cm.filter3(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc97) and not c:IsCode(m)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.filter3,tp,0x01,0,nil)
	local ct=mg:GetClassCount(Card.GetCode)
	if chk==0 then
		return ct>0 and c:IsAbleToRemoveAsCost() 
	end
	local g=Duel.GetMatchingGroup(cm.cfil1,tp,0x10,0,c)
	local gc=Group.CreateGroup()
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,ct,nil)
		if #sg>0 then gc:Merge(sg) end
	end
	gc:Merge(c)
	Duel.Remove(gc,POS_FACEUP,REASON_COST)
	e:SetLabel(#gc)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.filter3,tp,0x01,0,nil)
	local ct=e:GetLabel()
	if mg:GetClassCount(Card.GetCode)>ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=mg:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
		local s=0
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=1 then s=s+1 end
		if s==1 then
			local fg=Duel.GetFieldGroup(tp,0,0x02)
			local dc=2
			if #fg==1 then dc=#fg end
			if dc>0 then
				Duel.BreakEffect()
				local g2=fg:RandomSelect(tp,dc)
				Duel.SendtoGrave(g2,REASON_EFFECT+REASON_DISCARD)
			end
		else
			Duel.ConfirmCards(1-tp,g)
		end
	end	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.o1va3)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
