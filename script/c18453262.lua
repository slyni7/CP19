--플라나 몰리아
local m=18453262
local cm=_G["c"..m]
function cm.initial_effect(c)
	Diffusion.AddProcCode(c,cm.pfil1,18453260,true)
	local e1=MakeEff(c,"I","M")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
end
cm.custom_type=CUSTOMTYPE_DIFFUSION
function cm.pfil1(c)
	return c:IsCode(18453257)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2eb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevel(4) and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"H",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,"H")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"H",0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end