--귀정 세라픽 치킨
--카드군 번호: 0xc8c
local m=81237080
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.cn1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.co1)
	c:RegisterEffect(e1)

	--듀얼 몬스터를 일반 소환한다
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x08)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(0x08)
	e3:SetTargetRange(0x04,0)
	e3:SetTarget(cm.tg3)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_REMOVE)
	e4:SetTargetRange(1,1)
	e4:SetTarget(cm.tg4)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	
	--회수
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(0x10)
	e5:SetCountLimit(1,m)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end

--패에서 발동
function cm.cfil0(c)
	return c:IsAbleToGraveAsCost() and c:IsDiscardable()
	and (c:IsType(TYPE_DUAL) or c:IsSetCard(0xc8c) and c:IsType(0x2+0x4))
end
function cm.cn1(e)
	return Duel.IsExistingMatchingCard(cm.cfil0,e:GetHandlerPlayer(),0x02,0,1,e:GetHandler())
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x02,0,1,1,e:GetHandler())
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
end

--일반 소환
function cm.filter1(c)
	return c:IsSummonable(true,nil) and c:IsType(TYPE_DUAL)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.filter1,tp,0x02+0x04,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.filter2(c)
	return c:IsSSetable() and c:IsSetCard(0xc8c) and c:IsType(0x2+0x4)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,0x02+0x04,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.Summon(tp,tc,true,nil) then
		local og=Duel.GetMatchingGroup(cm.filter2,tp,0x01,0,nil)
		if tc:IsSetCard(0xc8c) and #og>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=og:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc and Duel.SSet(tp,tc)~=0 then
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	end	
end

--내성
function cm.tg3(e,c)
	return c:IsFaceup() and (c:IsType(TYPE_NORMAL) or c:IsSetCard(0xc8c))
end
function cm.va3(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function cm.tg4(e,c,tp,r,re)
	return c:IsControler(e:GetHandlerPlayer()) and c:IsLocation(0x04) and cm.tg3(e,c) and r&REASON_EFFECT~=0
end

--회수
function cm.tfil0(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xc8c)
end
function cm.tfil1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_DUAL) and c:IsLevelAbove(8)
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x10) and chkc:IsControler(tp) and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x08)>0
		and Duel.IsExistingTarget(cm.tfil0,tp,0x10,0,2,e:GetHandler())
		and Duel.IsExistingMatchingCard(cm.tfil1,tp,0x01,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0x10,0,2,2,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x08)<=0 then
		return
	end
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg and c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,0x08,POS_FACEUP,true) then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		local ct=g:FilterCount(Card.IsLocation,nil,0x01+0x40)
		local og=Duel.GetMatchingGroup(cm.tfil1,tp,0x01,0,nil)
		if ct>0 and #og>0 and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=og:Select(tp,1,1,nil)
			if #sg>0 then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end
