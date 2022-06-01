--Dark «µ«ó«À??«Ü«ë«È & Raikegi Hole
local m=99000096
local cm=_G["c"..m]
function cm.initial_effect(c)
	--trap act in hand
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(ea)
	--act in set turn
	local eb=ea:Clone()
	eb:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	eb:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(eb)
	--immune
	local ec=ea:Clone()
	ec:SetCode(EFFECT_IMMUNE_EFFECT)
	ec:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ec:SetValue(cm.efilter)
	c:RegisterEffect(ec)
	--0
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(LOCATION_PZONE)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	--1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetTarget(cm.chainlim1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--2
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,7))
	e2:SetTarget(cm.chainlim2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--3
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,8))
	e3:SetTarget(cm.chainlim3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	if not SpinelTable then SpinelTable={} end
	table.insert(SpinelTable,e1)
	table.insert(SpinelTable,e2)
	table.insert(SpinelTable,e3)
	table.insert(UnlimitChain,e1)
	table.insert(UnlimitChain,e2)
	table.insert(UnlimitChain,e3)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoExtraP(e:GetHandler(),nil,0,REASON_RULE)
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.chainlim1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chainlim2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chainlim3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,9))+1
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if op==1 then
		Duel.Destroy(sg,REASON_EFFECT)
	elseif op==2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,10),aux.Stringid(m,11))+10
	elseif op==3 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	elseif op==4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+20
	elseif op==5 then
		op=Duel.SelectOption(tp,aux.Stringid(99000097,14),aux.Stringid(99000097,15))+30
	elseif op==6 then
		Duel.Delete(e,sg)
	else
	end
	if op==10 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	elseif op==11 then
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	elseif op==20 then
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	elseif op==21 then
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
	elseif op==30 then
		Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
	elseif op==31 then
		Duel.SendtoDeck(sg,1-tp,2,REASON_EFFECT)
	else
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,9))+1
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,e:GetHandler())
	if op==1 then
		Duel.Destroy(sg,REASON_EFFECT)
	elseif op==2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,10),aux.Stringid(m,11))+10
	elseif op==3 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	elseif op==4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+20
	elseif op==5 then
		op=Duel.SelectOption(tp,aux.Stringid(99000097,14),aux.Stringid(99000097,15))+30
	elseif op==6 then
		Duel.Delete(e,sg)
	else
	end
	if op==10 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	elseif op==11 then
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	elseif op==20 then
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	elseif op==21 then
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
	elseif op==30 then
		Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
	elseif op==31 then
		Duel.SendtoDeck(sg,1-tp,2,REASON_EFFECT)
	else
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3),aux.Stringid(m,4),aux.Stringid(m,5),aux.Stringid(m,9))+1
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,e:GetHandler())
	if op==1 then
		Duel.Destroy(sg,REASON_EFFECT)
	elseif op==2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,10),aux.Stringid(m,11))+10
	elseif op==3 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	elseif op==4 then
		op=Duel.SelectOption(tp,aux.Stringid(m,12),aux.Stringid(m,13))+20
	elseif op==5 then
		op=Duel.SelectOption(tp,aux.Stringid(99000097,14),aux.Stringid(99000097,15))+30
	elseif op==6 then
		Duel.Delete(e,sg)
	else
	end
	if op==10 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	elseif op==11 then
		Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	elseif op==20 then
		Duel.SendtoHand(sg,tp,REASON_EFFECT)
	elseif op==21 then
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
	elseif op==30 then
		Duel.SendtoDeck(sg,tp,2,REASON_EFFECT)
	elseif op==31 then
		Duel.SendtoDeck(sg,1-tp,2,REASON_EFFECT)
	else
	end
end