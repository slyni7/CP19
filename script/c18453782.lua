--It's dark inside
local m=18453782
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK)
	end
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"E")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0x2045,0x4011,2500,1200,6,RACE_FIEND,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,m+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		if Duel.IsPlayerCanProcedureSummonGroup(tp,SUMMON_TYPE_SKULL) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.ProcedureSummonGroup(tp,SUMMON_TYPE_SKULL)
		end
	end
end