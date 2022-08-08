--리버사이드 마이스터
local m=18453524
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_RECOVER)
	WriteEff(e1,1,"NCTO")
	c:RegisterEffect(e1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.IsChainDisablable(ev) and (rc:IsLoc("G") or re:IsHasCategory(CATEGORY_SEARCH+CATEGORY_DRAW)) and rp~=tp
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SOI(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		Duel.BreakEffect()
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end