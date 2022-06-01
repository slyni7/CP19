--극악의 귀걸조
--카드군 번호: 0xc87
local m=81245060
local cm=_G["c"..m]
function cm.initial_effect(c)


	--패에서 발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.cn1)
	c:RegisterEffect(e1)
	
	--발동
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--발동
function cm.cfil0(c)
	return c:IsDiscardable() and c:IsSetCard(0xc87) and c:IsType(0x1)
end
function cm.cn1(e)
	return Duel.GetCurrentChain()>1 and Duel.IsExistingMatchingCard(cm.cfil0,e:GetHandlerPlayer(),0x02,0,1,nil)
end
function cm.nfil0(c)
	return c:IsFaceup() and c:IsCode(81245010)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.nfil0,tp,0x0c,0,1,nil)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.DiscardHand(tp,cm.cfil0,1,1,REASON_COST+REASON_DISCARD)
	end
end
function cm.tfil0(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsControler(1-tp) and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.tfil0,tp,0,0x04,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0,0x04,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsSummonType(SUMMON_TYPE_SPECIAL) then
			Duel.BreakEffect()
			local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,0x0c,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local sg=g:Select(tp,1,2,nil)
			if #sg>0 then
				Duel.HintSelection(sg)
				Duel.SendtoGrave(sg,REASON_EFFECT)
			end
		end
	end
end
