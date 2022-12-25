--죄와 벌
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local atk=rc:GetAttack()
	if chk==0 then
		return Duel.CheckLPCost(tp,atk) and (atk>=2000 or not c:IsLoc("H"))
	end
	Duel.PayLPCost(tp,atk)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain(true)==0
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local at1={}
	local at2={}
	local tc=eg:GetFirst()
	while tc do
		if tc:GetAttack()>0 and at1[tc:GetAttack()]==nil then
			at1[tc:GetAttack()]=true
			table.insert(at2,tc:GetAttack())
		end
		tc=eg:GetNext()
	end
	local b1=false
	local b2=false
	for i=1,#at2 do
		local atk=at2[i]
		if Duel.CheckLPCost(tp,atk) then
			b1=true
		end
		if atk>=2000 and Duel.CheckLPCost(tp,atk) then
			b2=true
		end
	end
	if chk==0 then
		return b1 and (b2 or not c:IsLoc("H"))
	end
	local at={}
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		for i=1,#at2 do
			if at2[i]>=2000 then
				table.insert(at,at2[i])
			end
		end
	else
		for i=1,#at2 do
			table.insert(at,at2[i])
		end
	end
	if #at==1 then
		Duel.PayLPCost(tp,at[1])
		e:SetLabel(at[1])
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local ac=Duel.AnnounceNumber(tp,table.unpack(at))
		Duel.PayLPCost(tp,ac)
		e:SetLabel(ac)
	end
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local atk=e:GetLabel()
	local g=eg:Filter(Card.IsAttackBelow,nil,atk)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	local g=eg:Filter(Card.IsAttackBelow,nil,atk)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
