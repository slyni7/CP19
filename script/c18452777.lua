--욕망과 욕망의 항아리
local m=18452777
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function cm.cfil1(c)
	return c:IsFacedown() and c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GMGroup(cm.cfil1,tp,"E",0,nil)
	local g2=Duel.GetDecktopGroup(tp,10)
	if chk==0 then
		return #g1>5 and g2:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==10
			and Duel.GetFieldGroupCount(tp,LSTN("D"),0)>13
	end
	Duel.DisableShuffleCheck()
	local rg=g1:RandomSelect(tp,6)
	rg:Merge(g2)
	Duel.Remove(rg,POS_FACEDOWN,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,4)
	end
	Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,4)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,4,REASON_EFFECT)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_CANNOT_DRAW)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTR(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end