--약식명령
local m=32415004
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(cm.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_CHAINING)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"A")
	e3:SetCode(EVENT_SPSUMMON)
	e3:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	WriteEff(e3,2,"C")
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function cm.con1(e)
	local res,eg,ep,ev,re,r,rp=Duel.CheckEvent(EVENT_CHAINING,true)
	if not res then
		return false
	end
	local rc=re:GetHandler()
	local se=rc:GetReasonEffect()
	if not se then
		return false
	end
	return rc:IsSummonType(SUMMON_TYPE_SPECIAL) and se:IsActiveType(TYPE_SPELL) and se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_LOCATION)
	local cc=Duel.GetCurrentChain()
	if ev~=cc then
		loc=Duel.GetChainInfo(cc-1,CHAININFO_TRIGGERING_LOCATION)
	end
	local rc=re:GetHandler()
	return loc&LSTN("O")>0
		and ((re:IsActiveType(TYPE_MONSTER) and rc:IsSummonType(SUMMON_TYPE_SPECIAL))
			or re:IsActiveType(TYPE_SPELL))
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1800)
	end
	Duel.PayLPCost(tp,1800)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()<1
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SOI(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end