--낭만의 지속시간(에이프릴 새턴)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddEqualProcedure(c,8,4,nil,nil,1,99,nil)
	local e1=MakeEff(c,"FC","M")
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	WriteEff(e1,1,"NO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","M")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,id)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
end
function s.nfil1(c,tp)
	return c:GetPreviousTypeOnField()&TYPE_TOKEN~=0 and c:IsPreviousControler(tp)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil1,1,nil,tp)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_UPDATE_NOTE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function s.nfil2(c)
	return c:IsCustomType(CUSTOMTYPE_EQUAL) and c:IsSummonType(SUMMON_TYPE_EQUAL)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(s.nfil2,1,c)
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function s.tfil2(c)
	if not c:IsCustomType(CUSTOMTYPE_EQUAL) then
		return false
	end
	local ch=c:GetChart()
	local nt=c:GetChart()
	return ch>0 and nt>0
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=1 then
			return false
		end
		e:SetLabel(0)
		return Duel.GetLocCount(tp,"M")>1 and Duel.IEMCard(s.tfil2,tp,"E",0,1,nil)
			 and Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SMCard(tp,s.tfil2,tp,"E",0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabelObject({tc:GetChart(),tc:GetNote()})
	Duel.ConfirmCards(1-tp,g)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,2,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<2
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY) then
		return
	end
	local lo=e:GetLabelObject()
	for i=1,2 do
		local token=Duel.CreateToken(tp,18453725)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lo[i])
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFinaleState()
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReleasable()
	end
	Duel.Release(c,REASON_COST)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local ec=e:GetLabel()==1 and c or nil
		e:SetLabel(0)
		return Duel.GetMZoneCount(tp,c)>3
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,"E",4,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,4,0,0)
end
function s.ofil3(c)
	return c:IsSpecialSummonable(SUMMON_TYPE_EQUAL)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<4
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY) then
		return
	end
	for i=0,3 do
		local token=Duel.CreateToken(tp,18453725)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1<<i)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
	local g=Duel.SMCard(tp,s.ofil3,tp,"E",0,0,1,nil)
	if #g>0 then
		Duel.BreakEffect()
		Duel.SpecialSummonRule(tp,g:GetFirst(),SUMMON_TYPE_EQUAL)
	end
end