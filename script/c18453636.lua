--교만의 지명자
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
end
function s.cfil1(c)
	return c:IsSetCard("지명자") and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.cfil1,tp,"H",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SMCard(tp,s.cfil1,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tfil2(c,e,tp)
	return c:IsSetCard("지명자") and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"D",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"D")
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SMCard(tp,s.tfil2,tp,"D",0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end