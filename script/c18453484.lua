--네버 비 더 세임
local m=18453484
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e1,1,"NC")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","F")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","F")
	e4:SetCode(EVENT_CHAINING)
	WriteEff(e4,4,"O")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","F")
	e5:SetCode(EFFECT_CANNOT_SSET)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTR(1,0)
	e5:SetTarget(cm.tar5)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"F","F")
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTR(1,0)
	e6:SetValue(cm.val6)
	c:RegisterEffect(e6)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1)
		and (not Duel.CheckPhaseActivity() or (Duel.GetFlagEffect(tp,CARD_MAGICAL_MIDBREAKER)>0 and Duel.GetCurrentChain()==1))
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 then
		return
	end
	Duel.Hint(HINT_CARD,0,m)
	local tc=eg:GetFirst()
	while tc do
		local e1=MakeEff(c,"F","F")
		e1:SetCode(EFFECT_CANNOT_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetTR(1,1)
		e1:SetLabel(code)
		e1:SetTarget(cm.otar21)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		c:RegisterEffect(e2)
		tc=eg:GetNext()
	end
end
function cm.otar21(e,c)
	return c:IsCode(e:GetLabel())
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)==0 then
		return
	end
	Duel.Hint(HINT_CARD,0,m)
	local code=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CODE)
	local e1=MakeEff(c,"F","F")
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetTR(1,1)
	e1:SetLabel(code)
	e1:SetValue(cm.oval41)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetReset(RESET_CHAIN)
	e2:SetLabelObject(e1)
	e2:SetLabel(ev)
	e2:SetOperation(cm.oop42)
	Duel.RegisterEffect(e2,tp)
end
function cm.oval41(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsCode(e:GetLabel())
end
function cm.oop42(e,tp,eg,ep,ev,re,r,rp)
	if ev==e:GetLabel() then
		e:GetLabelObject():Reset()
	end
end
function cm.tar5(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function cm.val6(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end