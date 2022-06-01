--그림자의 참상
--카드군 번호: 0xcb3
local m=81160160
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.cn2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(0x08)
	c:RegisterEffect(e3)
	
	--회수
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(0x10)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.co4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	
	--소환권 추가
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e5:SetRange(0x08)
	e5:SetTargetRange(0x02+0x04,0)
	e5:SetCondition(cm.cn5)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcb3))
	c:RegisterEffect(e5)
end

--발동
function cm.nfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xcb3) and c:IsType(TYPE_SYNCHRO)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	local ex4,g4,gc4,dp4,dv4=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex5,g5,gc5,dp5,dv5=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex6=re:IsHasCategory(CATEGORY_HANDES)
	local ex7=re:IsHasCategory(CATEGORY_SEARCH)
	local ex8=re:IsHasCategory(CATEGORY_DRAW)
	return (
		(ex2 and bit.band(dv2,0x0c)==0x0c)
	or	(ex3 and (bit.band(dv3,0x0c)==0x0c or bit.band(dv3,0x10)==0x10))
	or	(ex4 and (bit.band(dv4,0x02)==0x02 or bit.band(dv4,0x0c)==0x0c))
	or	(ex5 and (bit.band(dv5,0x01)==0x01 or bit.band(dv5,0x0c)==0x0c))
	or ex6 or ex7 or ex8
	)
	and ep~=tp
	and Duel.IsExistingMatchingCard(cm.nfil0,tp,0x04,0,1,nil) 
	and Duel.IsChainNegatable(ev)
end
function cm.nfil1(c)
	return c:IsReleasable() and c:IsAttribute(0x20)
end
function cm.cn2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.nfil1,tp,0x04,0,1,nil) and cm.cn1(e,tp,eg,ep,ev,re,r,rp)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local c=e:GetHandler()
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,cm.nfil1,tp,0x04,0,1,1,nil)
		Duel.Release(g,REASON_COST)
	end
	if c:IsType(TYPE_CONTINUOUS) and c:IsOnField() and c:IsFaceup() and c:IsAbleToGraveAsCost() then
		Duel.SendtoGrave(c,REASON_COST)
	end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--회수
function cm.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.nfil1,tp,0x04,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.nfil1,tp,0x04,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x08)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x08)<=0 then
		return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,0x08,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(0x20004)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e1)
	end
end

--소환권 추가
function cm.cn5(e)
	return e:GetHandler():GetType(0x20004)==0x20004
end
