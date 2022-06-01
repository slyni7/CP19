--간장 치킨
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"I","G")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,id)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	WriteEff(e2,2,"N")
	c:RegisterEffect(e2)
end
function s.nfil1(c)
	return (c:IsFaceup() or c:IsLoc("G")) and c:IsCode(83764718)
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(s.nfil1,tp,"OG",0,1,nil)
end
function s.tfil1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard("치킨") and not c:IsCode(id)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocCount(tp,"M")>1
			and Duel.IEMCard(s.tfil1,tp,"H",0,1,nil,e,tp)
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,c,2,tp,"HG")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"M")<2 or not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,s.tfil1,tp,"H",0,1,1,nil,e,tp)
	if #g>0 then
		g:AddCard(c)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.nfil1,tp,"OG",0,1,nil)
end