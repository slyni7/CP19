--프랙탈 사인
local m=99970562
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_REMOVE)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[-1]=Effect.CreateEffect(c)
		local ge1=MakeEff(c,"FC")
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.gop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=MakeEff(c,"FC")
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.gop2)
		Duel.RegisterEffect(ge2,0)
	end
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	if chk==0 then
		return tc1 and tc1:IsAbleToRemove() and tc2 and tc2:IsAbleToRemove()
	end
	local g=Group.FromCards(tc1,tc2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,PLAYER_ALL,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetDecktopGroup(tp,1):GetFirst()
	local tc2=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	local g=Group.FromCards(tc1,tc2)
	if #g<1 then
		return
	end
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		local cc=Duel.GetCurrentChain()
		local v=cm[0]
		if v>cc then
			local cg=Group.CreateGroup()
			local ge=cm[-1]
			for i=cc+1,v do
				local tc=cm[i]
				if tc:IsRelateToEffect(ge) then
					cg:AddCard(tc)
				end
			end
			if #cg>0 then
				ct=ct+Duel.Remove(cg,POS_FACEUP,REASON_EFFECT)
			end
		end
		Duel.BreakEffect()
		Duel.Recover(tp,ct*700,REASON_EFFECT)
	end
end
function cm.gop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	cm[0]=Duel.GetCurrentChain()
	cm[Duel.GetCurrentChain()]=rc
	if rc:IsRelateToEffect(re) then
		ge=cm[-1]
		rc:CreateEffectRelation(ge)
	end
end
function cm.gop2(e,tp,eg,ep,ev,re,r,rp)
	local v=cm[0]
	for i=1,v do
		cm[i]=nil
	end
end