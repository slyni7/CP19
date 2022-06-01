--기연개막
--카드군 번호: 0xcba
local m=81232090
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--묘지 유발
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--선택 효과
function cm.cfilter1(c)
	return c:IsAbleToGraveAsCost() and c:IsFacedown() and c:IsSetCard(0xcba)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x0c,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x0c,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetValue(g:GetFirst():GetCode())
end
function cm.tfilter1(c,code)
	return c:IsAbleToHand() and c:IsSetCard(0xcba) and (not c:IsCode(code) and not c:IsCode(m))
end
function cm.filchk(c)
	return c:IsFaceup() and c:IsCode(81232080)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local b2=Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x01,0,1,nil,e:GetValue())
	if chk==0 then
		return b1 or b2
	end
	local op=0
	if b1 and b2 then
		if Duel.IsExistingMatchingCard(cm.filchk,tp,0x0c+0x10,0,1,nil) then
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	e:SetLabel(op)
	if op~=0 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
		if op==1 then
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		else
			e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DRAW)
			Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		end
	else
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	local res=0
	if op~=1 then
		if e:SetProperty(EFFECT_FLAG_PLAYER_TARGET) then
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(tp,d,REASON_EFFECT)
		else
			res=Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,0x01,0,1,1,nil,e:GetValue())
		if #g>0 then
			if op==2 and res~=0 then Duel.BreakEffect() end
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

--묘지로 보낸다 또는 패에 넣는다
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.tfilter2(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x1cba) and c:IsType(0x1)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfilter2,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tfilter2,tp,0x01,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsLevelAbove(5) and tc:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
