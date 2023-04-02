--30만원짜리 달의 서
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"CO")
	c:RegisterEffect(e2)
end
function s.cfil2(c)
	return c:IsCanTurnSet() or c:IsAbleToRemoveAsCost(POS_FACEDOWN)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil2,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,s.cfil2,tp,"M","M",1,1,nil)
	local tc=g:GetFirst()
	if tc:IsCanTurnSet() then
		e:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		e:SetProperty(0)
	else
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-3000)
end