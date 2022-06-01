--케세라세라
local m=18453326
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC")
	e2:SetCode(EVENT_SSET)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetValue(0)
	WriteEff(e2,2,"NO")
	Duel.RegisterEffect(e2,0)
	local e3=MakeEff(c,"A")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_DICE)
	e3:SetHintTiming(0x5ff)
	e3:SetD(m,0)
	e3:SetLabelObject(e2)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"A")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetD(m,1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"Qo","G")
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCategory(CATEGORY_TOHAND)
	WriteEff(e5,5,"CTO")
	c:RegisterEffect(e5)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	if ph>0x7 and ph<0x41 then
		ph=0x80
	end
	c:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+ph,0,1)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m)<1
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DICE,nil,0,tp,1)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.TossDice(tp,1)
	if c:IsRelateToEffect(e) and c:IsCanTurnSet() then
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local te=c:IsHasEffect(m)
		local desc=32415005*16-31
		if not te then
			desc=desc+d
			local e1=MakeEff(c,"S")
			e1:SetCode(m)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetD(desc>>4,desc%16)
			e1:SetLabel(d)
			e1:SetReset(RESET_EVENT+0x1ec0000)
			c:RegisterEffect(e1)
		else
			local l=te:GetLabel()
			local s=l&0xffff
			desc=desc+s*6+d
			te:Reset()
			local e1=MakeEff(c,"S")
			e1:SetCode(m)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetD(desc>>4,desc%16)
			e1:SetLabel((s<<16)|d)
			e1:SetReset(RESET_EVENT+0x1ec0000)
			c:RegisterEffect(e1)
		end
	end
end
function cm.nfun4(d)
	local ph=Duel.GetCurrentPhase()
	local phase={PHASE_DRAW,PHASE_STANDBY,PHASE_MAIN1,PHASE_BATTLE,PHASE_MAIN2,PHASE_END}
	if d==4 then
		return ph>PHASE_MAIN1 and ph<PHASE_MAIN2
	else
		return ph==phase[d]
	end
	return false
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=c:IsHasEffect(m)
	if te then
		local l=te:GetLabel()
		local f=l>>16
		local s=l&0xffff
		return (f and cm.nfun4(f)) or (s and cm.nfun4(s))
	end
	return false
end
function cm.tfun4()
	local p=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	local phase={PHASE_DRAW,PHASE_STANDBY,PHASE_MAIN1,PHASE_BATTLE,PHASE_MAIN2,PHASE_END}
	local skip={EFFECT_SKIP_DP,EFFECT_SKIP_SP,EFFECT_SKIP_M1,EFFECT_SKIP_BP,EFFECT_SKIP_M2,EFFECT_SKIP_EP}
	for i=1,11 do
		local res=true
		local o=i>5
		local sph=(o and phase[i-5]) or phase[i+1]
		res=res and (o or (sph>ph))
		local sp=(o and 1-p) or p
		local sskip=(o and skip[i-5]) or skip[i+1]
		res=res and not Duel.IsPlayerAffectedByEffect(sp,sskip)
		if not o and sph>PHASE_MAIN1 and sph<PHASE_END then
			res=res and Duel.IsAbleToEnterBP()
		elseif o then
			res=res and not Duel.IsPlayerAffectedByEffect(sp,EFFECT_SKIP_TURN)
		end
		if res then
			return sp,sph
		end
	end
	return false
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return cm.tfun4()
	end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if cm.tfun4() then
		local sp,sph=cm.tfun4()
		Duel.SkipPhase(sp,sph,RESET_PHASE+PHASE_END,1)
	end
end
function cm.cfil5(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToRemoveAsCost()
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil5,tp,"G",0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.cfil5,tp,"G",0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end