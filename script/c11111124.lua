--μ(마이크로) 폭스
local m=11111124
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.nfil2(c)
	return c:IsSetCard(0x1f5)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.nfil2,1,nil)
	return ep==tp and #g==1
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.nfil2,1,nil)
	local tc=g:GetFirst()
	if chk==0 then
		return tc:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local b1=#g1>0
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local b2=#g2>0
	if chk==0 then
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,0,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local b1=#g1>0
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local b2=#g2>0
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
	if off==1 then
		return
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
		local tc=g1:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-900)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=g1:GetNext()
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g2:Select(tp,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end