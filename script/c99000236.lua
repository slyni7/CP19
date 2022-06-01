--레이 아 말리니타스
local m=99000236
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,cm.ffilter,3,63,true)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.immcon)
	e1:SetOperation(cm.immop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.matcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function cm.ffilter(c,fc)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function cm.immcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsCode(48130397) and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()>=3 then
		--Activate
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(cm.condition)
		e1:SetCost(cm.cost)
		e1:SetTarget(cm.target)
		e1:SetOperation(cm.activate)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e1)
	end
	if e:GetLabel()>=6 then
		--act limit
		local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(m,1))
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e4:SetCode(EVENT_CHAINING)
		e4:SetRange(LOCATION_MZONE)
		e4:SetOperation(cm.chainop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e4)
	end
end
function cm.matcheck(e,c)
	local ct=c:GetMaterialCount()
	if ct>=3 then
		e:GetLabelObject():SetLabel(3)
	end
	if ct>=6 then
		e:GetLabelObject():SetLabel(6)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetCurrentChain()>=2 and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99000236)==0 end
	Duel.RegisterFlagEffect(tp,99000236,RESET_CHAIN,0,1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		if te:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsRelateToEffect(te) then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if te:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
			and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) then
			dg:AddCard(tc)
		end
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) then
		Duel.SetChainLimit(aux.FALSE)
	end
end