--고귀한 선령 - 순호
--카드군 번호: 0xc9f
local m=81254030
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()

	--효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--퍼미션
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

--효과
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0x0c,0)==1
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,0x02,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.cva1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.cva1(e,re,tp)
	return re:IsActiveType(0x1) and not re:GetHandler():IsSetCard(0xc9f)
end
function cm.tfil0(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.tfil0,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler())
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
	local b3=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,0x10+0x20,1,nil)
	if chk==0 then
		return b1 or b2 or b3 
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
	if b3 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_DESTROY)
		local g1=Duel.GetMatchingGroup(cm.tfil0,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,#g1,0,0)
	elseif sel==2 then
		e:SetCategory(CATEGORY_DESTROY)
		local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,#g2,0,0)
	elseif sel==3 then
		e:SetCategory(CATEGORY_TODECK)
		local g3=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,0x10+0x20,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g3,#g3,0,0)
	end	
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		local g1=Duel.GetMatchingGroup(cm.tfil0,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
		Duel.Destroy(g1,REASON_EFFECT)
	elseif sel==2 then
		local g2=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		Duel.Destroy(g2,REASON_EFFECT)
	elseif sel==3 then
		local g3=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,0x10+0x20,nil)
		Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
	end
end

function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0x0c,0)==1 
	and rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
