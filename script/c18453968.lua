--이상물질(아이딜 매터) 「청량」
local s,id=GetID()
function s.initial_effect(c)
	if not s.global_check then
		s.global_check=true
		aux.RegisterIdealMatter(c,id)
	end
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,600,600,1,RACE_CYBERSE,ATTRIBUTE_WATER)
	end
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,600,600,1,RACE_CYBERSE,ATTRIBUTE_WATER) then
		while true do
			local token=Duel.CreateToken(tp,id+1)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			if not (Duel.GetLocCount(tp,"M")>0
				and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN,600,600,1,RACE_CYBERSE,ATTRIBUTE_WATER))
				or not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				break
			end
		end
		Duel.SpecialSummonComplete()
	end
	local ct=1
	local e1=MakeEff(c,"FC")
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		ct=2
		e1:SetLabel(Duel.GetTurnCount())
	end
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
	e1:SetCL(1)
	e1:SetCondition(s.ocon11)
	e1:SetOperation(s.oop11)
	Duel.RegisterEffect(e1,tp)
end
function s.onfil111(c)
	return c:IsCode(id+1) and c:IsReleasable()
end
function s.onfil112(c)
	return ((c:IsOnField() and c:IsFaceup())
		or c:IsLoc("G") or (c:IsLoc("R") and c:IsFaceup())) and (c:IsAbleToDeck() or c:IsNegatable())
end
function s.ocon11(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.onfil111,tp,"O",0,1,nil)
		and Duel.IEMCard(s.onfil112,tp,0,"OGR",1,nil)
		and Duel.GetTurnCount()~=e:GetLabel()
end
function s.oop11(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GMGroup(s.onfil111,tp,"O",0,nil)
	local g2=Duel.GMGroup(s.onfil112,tp,0,"OGR",nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg1=g1:Select(tp,1,#g2,nil)
	local ct=Duel.Release(sg1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=g2:Select(tp,ct,ct,nil)
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		for tc in aux.Next(g) do
			local code=tc:GetOriginalCodeRule()
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTR(0,"O")
			e1:SetLabel(code)
			e1:SetTarget(s.ootar111)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=MakeEff(c,"FC")
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetLabel(code)
			e2:SetCondition(s.oocon112)
			e2:SetOperation(s.ooop112)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetTR(0,"M")
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function s.ootar111(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end
function s.oocon112(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsOriginalCodeRule(e:GetLabel()) and rp~=tp
end
function s.ooop112(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end