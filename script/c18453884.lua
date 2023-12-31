--vingt et un ~intrépide~
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","E")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","P")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetCL(1,id)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"S","M")
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCondition(s.con5)
	e5:SetValue(6000)
	c:RegisterEffect(e5)
end
function s.nfil2(c)
	return c:IsSetCard("vingt et un") and c:IsType(TYPE_PENDULUM)
end
function s.con2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp)>0 and Duel.IEMCard(s.nfil2,tp,"H",0,1,nil)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SMCard(tp,s.nfil2,tp,"H",0,1,1,nil)
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.nfil2,tp,"D",0,1,nil)
	end
	local c=e:GetHandler()
	Duel.SOI(0,CATEGORY_DESTROY,c,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SMCard(tp,s.nfil2,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.MoveToField(g:GetFirst(),tp,tp,LSTN("P"),POS_FACEUP,true)
		end
	end
end
function s.ofil4(c,tp)
	return c:IsSetCard("vingt et un")
		and (not c:IsDisabled() or (c:IsAbleToHand() and Duel.IsPlayerAffectedByEffect(tp,18453900)))
		and c:IsFaceup()
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GMGroup(s.ofil4,tp,"O",0,nil,tp)
	if rp~=tp and #g>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc:IsAbleToHand() and Duel.IsPlayerAffectedByEffect(tp,18453900) and (tc:IsDisabled() or Duel.SelectYesNo(tp,aux.Stringid(18453900,1))) then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		else
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_DISABLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			tc:RegisterEffect(e2)
		end
		local e3=MakeEff(c,"S","M")
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(s.oval43)
		e3:SetLabelObject(re)
		e3:SetReset(RESET_CHAIN)
		c:RegisterEffect(e3)
	end
end
function s.oval43(e,re)
	return re==e:GetLabelObject()
end
function s.con5(e)
	local c=e:GetHandler()
	return c:IsDisabled()
end