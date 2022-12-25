--뮤네뮤네☆나이트피버
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FTo","M")
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCL(1)
	WriteEff(e4,4,"NTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","M")
	e5:SetCode(EFFECT_NIGHT_FEVER_PAYLP_TO_RECOVER)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTR(1,0)
	e5:SetCondition(s.con5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_NIGHT_FEVER_DISCARD_TO_DRAW)
	c:RegisterEffect(e6)
end
function s.tfil1(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_COUNTER) and c:IsSSetable()
		and aux.CounterTrapNegateSpellList[c:GetOriginalCode()]
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end
function s.con4(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_COUNTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp
end
function s.tfil4(c,e,tp)
	return c:IsSetCard("나이트피버") and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(id)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil4,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SMCard(tp,s.tfil4,tp,"D",0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.con5(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(id)==0
end