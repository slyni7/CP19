--몽시공 - 차원 분열
--카드군 번호: 0xc97
local m=81261090
local cm=_G["c"..m]
function cm.initial_effect(c)

	--묘지제외
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--마함제외
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--묘지 기동
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(0x10)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--묘지 제외
function cm.cfil0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc97)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,0x10,nil)
	if chk==0 then
		return rt>0 and Duel.IsExistingMatchingCard(cm.cfil0,tp,0x02+0x10,0,1,c)
	end
	if rt>3 then rt=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x02+0x10,0,1,rt,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(#g)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x10,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x08+0x10)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<=0 then
		return
	end
	local cg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x10,nil)
	if #cg>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=cg:Select(tp,ct,ct,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT,false)
	end
end

--묘지 제외
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=Duel.GetMatchingGroupCount(Card.IsAbleToRemove,tp,0,0x08,nil)
	if chk==0 then
		return rt>0 and Duel.IsExistingMatchingCard(cm.cfil0,tp,0x02+0x10,0,1,c)
	end
	if rt>3 then rt=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x02+0x10,0,1,rt,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(#g)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x08,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x08+0x10)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct<=0 then
		return
	end
	local cg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x08,nil)
	if #cg>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=cg:Select(tp,ct,ct,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT,false)
	end
end

--서치
function cm.cfilter1(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xc97)
	and Duel.IsExistingMatchingCard(cm.tfilter0,tp,0x01+0x10+0x20,0,1,nil)
end
function cm.tfilter0(c)
	return (c:IsFaceup() or c:IsLocation(0x01) or c:IsLocation(0x10)) 
	and c:IsAbleToHand() and c:IsSetCard(0xc97) and c:IsType(0x1)
end
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x10,0,1,c,tp)
		and c:IsAbleToRemoveAsCost()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x10,0,1,1,c,tp)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01+0x10+0x20)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfilter0,tp,0x01+0x10+0x20,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
