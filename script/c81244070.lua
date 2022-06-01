--성령화의 기도
--카드군 번호: 0x307a
local m=81244070
local cm=_G["c"..m]
function cm.initial_effect(c)

	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--회복
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--드로우
function cm.cfil0(c)
	return c:IsSetCard(0x307a) and c:IsType(0x1)
end
function cm.cosel(g)
	return g:IsExists(cm.cfil0,1,nil)
end
function cm.mcfil0(c)
	return c:IsAbleToGraveAsCost() and ( c:IsLocation(0x02) or c:IsFaceup() )
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.mcfil0,tp,0x02+0x0c,0,e:GetHandler())
	if chk==0 then
		return g:CheckSubGroup(cm.cosel,2,2)
	end
	local rg=g:SelectSubGroup(tp,cm.cosel,false,2,2)
	Duel.SendtoGrave(rg,REASON_COST)
	if #rg>0 and not rg:IsExists(Card.IsSetCard,2,nil,0x307a) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if e:GetLabel()==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

--회복
function cm.tfil0(c)
	return c:IsFaceup() and c:IsSetCard(0x307a) and c:GetLevel()>0
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x20,0,nil)
	local val=g:GetSum(Card.GetLevel)*100
	if chk==0 then
		return val>0
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x20,0,nil)
	local val=g:GetSum(Card.GetLevel)*100
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,val,REASON_EFFECT)
end
