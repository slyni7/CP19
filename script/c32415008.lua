--I'm not D.D.crow!
local m=32415008
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_NEGATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.con2)
	e2:SetCost(cm.cost2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCountLimit(1,m+2)
	e3:SetCondition(cm.con3)
	c:RegisterEffect(e3)
	if not cm.glo_chk then
		cm.glo_chk=true
		cm[0]=Group.CreateGroup()
		cm[0]:KeepAlive()
		cm[1]=0
		cm[2]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_REMOVE)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_TO_DECK)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	if cc>0 and r&REASON_COST>0 then
		local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
		if cm[1]~=cid then
			cm[0]:Clear()
		end
		cm[0]:Merge(eg)
		cm[1]=cid
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	local cc=Duel.GetCurrentChain()
	if cc>0 and r&REASON_COST>0
		and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_GRAVE) then
		local cid=Duel.GetChainInfo(cc,CHAININFO_CHAIN_ID)
		cm[2]=cid
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local cg=cm[0]
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	local ct=(loc&LOCATION_HAND>0 and 1) or 0
	return cg:GetCount()>ct and cid==cm[1] and Duel.IsChainNegatable(ev)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=cm[0]
	if chk==0 then
		return cg:FilterCount(Card.IsAbleToRemoveAsCost,nil)==cg:GetCount()
			and c:IsDiscardable()
	end
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		rc:CancelToGrave()
		Duel.Remove(rc,POS_FACEUP,REASON_COST)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	return cid==cm[2] and Duel.IsChainNegatable(ev)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED)
		and rc:IsPreviousLocation(LOCATION_GRAVE)
		and rc:IsRelateToEffect(re) and Duel.IsChainNegatable(ev)
end