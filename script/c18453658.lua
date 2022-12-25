--베이고우후 시무르그
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCL(1,id)
	e2:SetD(id,0)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"STo")
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e4:SetD(id,1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.GetFieldGroupCount(tp,LSTN("M"),0)==0
end
function s.tfil2(c)
	return c:IsSetCard(0x12d) and c:IsMonster() and c:IsAbleToHand() and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonLocation(LSTN("H"))
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>1
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18453669,0x12d,TYPES_TOKEN,0,0,1,RACE_WINGEDBEAST,ATTRIBUTE_WIND)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,2,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18453669,0x12d,TYPES_TOKEN,0,0,1,RACE_WINGEDBEAST,ATTRIBUTE_WIND) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,18453698)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=MakeEff(c,"S")
			e1:SetCode(EFFECT_SIMORGH_EGG_TOKEN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			token:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end