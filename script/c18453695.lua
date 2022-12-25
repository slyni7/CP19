--천사날개의 폭풍
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_SUMMON)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"A")
	e3:SetCode(EVENT_CHAINING)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	WriteEff(e3,1,"C")
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"A")
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	WriteEff(e4,1,"C")
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FC","HS")
	e5:SetCode(EVENT_SPSUMMON_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	WriteEff(e5,5,"NO")
	Duel.RegisterEffect(e5,0)
	local e6=e5:Clone()
	Duel.RegisterEffect(e6,1)
end
function s.nfil1(c)
	return c:IsAttackPos() and c:IsAttackAbove(1200)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)==0 and eg:IsExists(s.nfil1,1,nil)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1200)
	end
	Duel.PayLPCost(tp,1200)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local g=eg:Filter(s.nfil1,nil)
	Duel.SOI(0,CATEGORY_DISABLE_SUMMON,g,#g,0,0)
	Duel.SOI(0,CATEGORY_REMOVE,g,#g,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.nfil1,nil)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and re:GetHandler():IsAttackAbove(1200)
		and re:GetHandler():IsAttackPos() and re:GetHandler():IsOnField()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:IsAttackAbove(1200)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
	end
	if a:IsRelateToBattle() then
		Duel.SOI(0,CATEGORY_DESTROY,a,1,0,0)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.NegateAttack() and a:IsRelateToBattle() and Duel.Destroy(a,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.nfil1,1,nil) and Duel.IsPlayerCanDraw(tp,1) and tp==c:GetControler()
		and ((c:IsLoc("S") and c:IsFacedown() and (not c:IsStatus(STATUS_SET_TURN) or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN)))
			or (c:IsLoc("H") and c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND)))
end
function s.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local c=e:GetHandler()
	local g=Group.FromCards(c)
	local sg=g:Select(tp,0,1,nil)
	if #sg==0 then
		return
	end
	if c:IsLoc("H") then
		Duel.MoveToField(c,tp,tp,LSTN("S"),POS_FACEUP,true)
	else
		Duel.ChangePosition(c,POS_FACEUP)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_CARD,0,id)
	c:CancelToGrave(false)
	local g=eg:Filter(s.nfil1,nil)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
	g:KeepAlive()
	aux.SpecialSummonByEffectNegatedGroup=g
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end