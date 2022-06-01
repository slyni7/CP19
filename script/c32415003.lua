--약식재판
local m=32415003
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_DESTROY)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE)))
		and Duel.IsChainNegatable(ev)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,2500)
	end
	Duel.PayLPCost(tp,2500)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local exg=Group.CreateGroup()
	if c:IsRelateToEffect(e) then
		exg:AddCard(c)
	end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		exg:Merge(eg)
	end
	local dg=Duel.GMGroup(aux.TRUE,tp,"O","O",exg)
	local rc=re:GetHandler()
	if Duel.GetFlagEffect(tp,m)<1 and #dg>0 then
		Duel.SOI(0,CATEGORY_DESTROY,dg,1,0,0)
	elseif rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=0
	local exg=Group.CreateGroup()
	if c:IsRelateToEffect(e) then
		exg:AddCard(c)
	end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		exg:Merge(eg)
	end
	local dg=Duel.GMGroup(aux.TRUE,tp,"O","O",exg)
	if #dg>0 and Duel.GetFlagEffect(tp,m)<1 then
		sel=Duel.SelectOption(tp,16*m,16*m+1)
	end
	if Duel.NegateActivation(ev) then
		if sel<1 then
			local rc=re:GetHandler()
			if rc:IsRelateToEffect(re) then
				Duel.Destroy(eg,REASON_EFFECT)
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=dg:Select(tp,1,1,nil)
			Duel.Destroy(sg,REASON_EFFECT)
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		end
	end
end