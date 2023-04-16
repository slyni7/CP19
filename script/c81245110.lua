--귀걸의 선고자
--카드군 번호: 0xc87
local m=81245110
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
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
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
	local c=e:GetHandler()
	local op=0
	if chk==0 then
		return Duel.CheckLPCost(tp,1500)
	end
	Duel.PayLPCost(tp,1500)
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.DiscardHand(tp,cm.cfil0,1,1,REASON_COST+REASON_DISCARD)
		c:RegisterFlagEffect(m+1,RESET_CHAIN,0,1)
	end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x02,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x40,1,nil)
	if chk==0 then
		return b1 or b2
	end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x02+0x40)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)

	--Group
	local c=e:GetHandler()
	local g1=Duel.GetFieldGroup(tp,0x02,0)
	local g2=Duel.GetFieldGroup(tp,0x40,0)
	local og1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x02,nil)
	local og2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x40,nil)
	local sel=e:GetLabel()
	local ct=1
	if c:GetFlagEffect(m+1)~=0 then ct=ct+1 end

	--solving
	if sel==1 and #og1>0 then
		if #g1>0 then
			Duel.ConfirmCards(1-tp,g1)
		end
		Duel.ConfirmCards(tp,og1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=og1:Select(tp,1,ct,nil)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	elseif sel==2 and #og2>0 then
		if #g2>0 then
			Duel.ConfirmCards(1-tp,g2)
		end
		Duel.ConfirmCards(tp,og2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=og2:Select(tp,1,ct,nil)
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	else
		return false
	end
end
