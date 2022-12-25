--그로골렘 시무르그
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTR(POS_FACEUP,1)
	e1:SetCondition(s.con1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","G")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetCL(1,id)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>1 and Duel.GetLocCount(1-tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18453669,0x12d,TYPES_TOKEN,0,0,1,RACE_WINGEDBEAST,ATTRIBUTE_LIGHT)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp,c)
	for i=1,2 do
		local token=Duel.CreateToken(tp,18453699)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SIMORGH_EGG_TOKEN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function s.tfil2(c)
	return c:IsSetCard(0x12d) and c:IsAbleToGrave()
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>0
			and Duel.IEMCard(s.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end