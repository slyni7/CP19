--[ Noblechain ]
local m=99970557
local cm=_G["c"..m]
function cm.initial_effect(c)

	--서치
	local e1=MakeEff(c,"A")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--수비력 증가
	local e2=MakeEff(c,"Qo","G")
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.not_damcal)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--노블체인
	local e0=MakeEff(c,"Qo","R")
	e0:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCL(1,m)
	WriteEff(e0,0,"NTO")
	c:RegisterEffect(e0)

end

--서치
function cm.cfilter(c)
	return c:IsSetCard(0xe15) and c:IsAbleToRemoveAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0xe15) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--수비력 증가
function cm.tfilter(c)
	return c:IsSetCard(0xe15) and c:IsFaceup()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.tfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(tc:GetDefense()*2)
		tc:RegisterEffect(e1)
	end
end

--노블체인
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==2
end
function cm.thfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.IsExistingMatchingCard(cm.thfilter,tp,0,LSTN("M"),1,nil) end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LSTN("M"),nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LOCATION_MZONE,nil)
	if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) and #g>0 then
			local tg=g:GetMinGroup(Card.GetLevel):Filter(Card.IsAbleToHand,nil)
			if #tg<1 then return end
			Duel.BreakEffect()
			if tg:GetCount()>1 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
				local sg=tg:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
			else Duel.SendtoHand(sg,nil,REASON_EFFECT) end
		end
	end
end
