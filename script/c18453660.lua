--스팀보그 시무르그
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","M")
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","G")
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCountLimit(1,id)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function s.nfil1(c)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsFaceup()
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(s.nfil1,tp,"M",0,1,nil)
end
function s.cfil2(c,ft,tp)
	return c:IsFaceup() and c:IsSetCard(0x12d)
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocCount(tp,"M")
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroupCost(tp,s.cfil2,1,false,nil,nil,ft,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfil2,1,1,false,nil,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function s.tfil2(c,e,tp)
	return c:IsSetCard(0x12d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil,e,tp) end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,18453669,0x12d,TYPES_TOKEN,0,0,1,RACE_WINGEDBEAST,ATTRIBUTE_WATER)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SOI(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18453669,0x12d,TYPES_TOKEN,0,0,1,RACE_WINGEDBEAST,ATTRIBUTE_WATER) then
		local token=Duel.CreateToken(tp,18453700)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_SIMORGH_EGG_TOKEN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function s.cfil4(c,ft,tp)
	return (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocCount(tp,"M")
	if chk==0 then
		return Duel.CheckReleaseGroupCost(tp,s.cfil4,1,false,nil,nil,ft,tp)
	end
	local sg=Duel.SelectReleaseGroupCost(tp,s.cfil4,1,1,false,nil,nil,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<=0 then
		return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end