--아세리마 플루토
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","S")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetCL(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLPCost(tp,1000)
	end
	Duel.PayLPCost(tp,1000)
end
function s.tfil21(c)
	return c:IsSetCard("아세리마") and c:IsType(TYPE_PENDULUM)
end
function s.tfil22(c)
	return c:IsSetCard("아세리마")
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return (Duel.CheckPendulumZones(tp) and Duel.IEMCard(s.tfil21,tp,"D",0,1,nil))
			or Duel.IEMCard(s.tfil22,tp,"P",0,2,nil)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IEMCard(s.tfil22,tp,"P",0,2,nil) then
		Duel.Recover(tp,2850,REASON_EFFECT)
	elseif Duel.CheckPendulumZones(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SMCard(tp,s.tfil21,tp,"D",0,1,1,nil)
		Duel.MoveToField(g:GetFirst(),tp,tp,LSTN("P"),POS_FACEUP,true)
	end
end