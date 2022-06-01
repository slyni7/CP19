--프로젝트 메모리즈(화려하게 아련하게 간절하게)
local m=32415005
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
	e3:SetD(m,12)
	e3:SetLabelObject(e2)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"A")
	e4:SetCode(EVENT_CHAINING)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetD(m,13)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"A")
	e5:SetCode(EVENT_SPSUMMON)
	e5:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e5:SetD(m,13)
	WriteEff(e5,4,"C")
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SUMMON)
	WriteEff(e6,6,"N")
	c:RegisterEffect(e6)
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
		local desc=m*16-31
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
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsChainNegatable(ev) then
		return false
	end
	local te=c:IsHasEffect(m)
	if te then
		local l=te:GetLabel()
		local f=l>>16
		local s=l&0xffff
		if re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
			and (f==1 or s==1 or f==4 or s==4 or f==6 or s==6) then
			return true
		end
		if re:IsActiveType(TYPE_MONSTER)
			and (f==2 or s==2 or f==3 or s==3 or f==6 or s==6) then
			return true
		end
		if re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
			and (f==2 or s==2 or f==4 or s==4 or f==5 or s==5) then
			return true
		end
	end
	return false
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,2100)
	end
	Duel.PayLPCost(tp,2100)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentChain()>0 then
		return false
	end
	local te=c:IsHasEffect(m)
	if te then
		local l=te:GetLabel()
		local f=l>>16
		local s=l&0xffff
		if f==1 or s==1 or f==3 or s==3 or f==5 or s==5 then
			return true
		end
	end
	return false
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SOI(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function cm.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentChain()>0 then
		return false
	end
	local te=c:IsHasEffect(m)
	if te then
		local l=te:GetLabel()
		local f=l>>16
		local s=l&0xffff
		if f==s then
			return true
		end
	end
	return false
end