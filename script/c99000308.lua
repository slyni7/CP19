--검과 기사의 맹약
local m=99000308
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Meiyaku
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_ACTIVATE_COST)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	ea:SetTargetRange(1,1)
	ea:SetTarget(cm.meiyakutg)
	ea:SetOperation(cm.meiyakuop)
	Duel.RegisterEffect(ea,0)
	--remain field
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(eb)
	--Activate
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_ACTIVATE)
	ec:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(ec)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCost(cm.descost)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.meiyakutg(e,te,tp)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return c==tc and not tc:IsLocation(LOCATION_SZONE) and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.meiyakuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99000295,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp)
		and Duel.SelectYesNo(tp,aux.Stringid(99000306,0)) then
		local token=Duel.CreateToken(tp,99000295)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
		Duel.MoveToField(c,tp,1-tp,LOCATION_FZONE,POS_FACEUP,false)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,67)
	else
		return true
	end
end
function cm.costfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost()
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		or (Duel.IsPlayerAffectedByEffect(tp,99000305) and e:GetHandler():GetFlagEffect(99000308)==0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetHandler():GetColumnGroup())) end
	if Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		and (not Duel.IsPlayerAffectedByEffect(tp,99000305) or e:GetHandler():GetFlagEffect(99000308)~=0
		or not Duel.SelectYesNo(tp,aux.Stringid(99000305,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
		e:GetHandler():RegisterFlagEffect(99000308,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.filter(c,g)
	return g:IsContains(c)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return ((Duel.GetCurrentPhase()==PHASE_MAIN1) or (Duel.GetCurrentPhase()==PHASE_MAIN2))
		and e:GetHandler():GetOwner()==tp
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local cg=e:GetHandler():GetColumnGroup()
	if chkc then return cm.filter(chkc,cg) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not c:IsRelateToEffect(e) or g:GetCount()==0 then return end
	if Duel.Destroy(g,REASON_EFFECT)==0 then return end
	local seq=0
	local og=Duel.GetOperatedGroup()
	local tc=og:GetFirst()
	while tc do
		seq=bit.lshift(0x1,tc:GetPreviousSequence())
		if tc:IsPreviousLocation(LOCATION_SZONE) then seq=seq*0x100 end
		if tc:GetPreviousControler()~=tp then seq=seq*0x10000 end
		tc=og:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetOperation(cm.disop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetLabel(seq)
	Duel.RegisterEffect(e1,tp)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tzone=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	local zone=bit.lshift(0x1,seq)
	if loc&LOCATION_SZONE~=0 then zone=zone*0x100 end
	if re:GetHandler():IsControler(1-tp) then zone=zone*0x10000 end
	if rp==1-tp and zone==tzone then
		Duel.NegateEffect(ev)
	end
	--존 메모
	--268435456 134217728 n n 16777216
	--1048576 524288 262144 131072 65536
	--	32 64
	--1 2 4 8 16
	--256 512 1024 2048 4096
end