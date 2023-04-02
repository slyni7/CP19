--벚꽃의 전야(에이프릴 페스)
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	e:SetLabel(1)
	return true
end
function s.tfil1(c)
	if not c:IsCustomType(CUSTOMTYPE_EQUAL) then
		return false
	end
	local ch=c:GetChart()
	local nt=c:GetNote()
	return ch>0 and nt>0
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=1 then
			return false
		end
		e:SetLabel(0)
		return Duel.GetLocCount(tp,"M")>1 and Duel.IEMCard(s.tfil1,tp,"E",0,1,nil)
			 and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_NORMAL,-2,0,0,RACE_CYBERSE,ATTRIBUTE_FAIRY)
			 and Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SMCard(tp,s.tfil1,tp,"E",0,1,1,nil)
	local tc=g:GetFirst()
	e:SetLabelObject({tc:GetChart(),tc:GetNote()})
	Duel.ConfirmCards(1-tp,g)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocCount(tp,"M")<1
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_NORMAL,-2,0,0,RACE_CYBERSE,ATTRIBUTE_FAIRY) then
		return
	end
	local lo=e:GetLabelObject()
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(id)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetReset(RESET_EVENT+0x1ec0000)
	c:RegisterEffect(e1)
	c:Level(lo[1])
	c:Type(TYPE_MONSTER+TYPE_NORMAL)
	local e2=MakeEff(c,"F","M")
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetAbsoluteRange(tp,1,0)
	e2:SetTarget(s.otar12)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC")
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(s.oop13)
	Duel.RegisterEffect(e3,tp)
	Duel.SpecialSummonComplete()
	if Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18453725,0,TYPES_TOKEN,-2,0,0,RACE_FAIRY,ATTRIBUTE_FAIRY) then
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,18453725)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e4=MakeEff(c,"S")
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetValue(lo[2])
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e4)
		local e5=e2:Clone()
		token:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
	end
end
function s.otar12(e,c)
	return c:IsLoc("E") and not c:IsCustomType(CUSTOMTYPE_EQUAL)
end
function s.oop13(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsHasEffect(id) then
		c:Type(TYPE_SPELL)
		c:Level(0)
	end
end