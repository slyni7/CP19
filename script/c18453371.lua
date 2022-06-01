--파닭 치킨
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCL(1,id)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.tfil1(c)
	return c:IsSetCard("치킨") and c:IsSSetable() and c:IsType(TYPE_TRAP)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"S")>0 and Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCondition(s.ocon11)
		tc:RegisterEffect(e1)
	end
end
function s.onfil11(c)
	return (c:IsFaceup() or c:IsLoc("G")) and c:IsCode(83764718)
end
function s.ocon11(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IEMCard(s.onfil11,tp,"OG",0,1,nil)
end