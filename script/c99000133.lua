--¹«³à ¹ÌÄÚÅä
local m=99000133
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Inactivate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(cm.discon)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		c99000133[0]=0
		c99000133[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(cm.clearop)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_SPECIAL) then
			local p=tc:GetSummonPlayer()
			c99000133[p]=c99000133[p]+1
		end
		tc=eg:GetNext()
	end
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
	c99000133[0]=0
	c99000133[1]=0
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local loc2=re:GetHandler():GetLocation()
	if loc==0x108 then
		return loc~=loc2 and loc2~=0x8 and rp==1-tp and Duel.IsChainDisablable(ev)
	elseif loc==0x208 then
		return loc~=loc2 and loc2~=0x8 and rp==1-tp and Duel.IsChainDisablable(ev)
	else
		return loc~=loc2 and rp==1-tp and Duel.IsChainDisablable(ev)
	end
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local ph=Duel.GetCurrentPhase()
	if tp==Duel.GetTurnPlayer() and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then
		Duel.Damage(tp,c99000133[tp]*400,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(cm.damcon)
		e1:SetOperation(cm.damop)
		if ph==PHASE_MAIN1 then
			e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		else
			e1:SetReset(RESET_PHASE+PHASE_MAIN2)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Damage(tp,400,REASON_EFFECT)
end