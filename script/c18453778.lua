--When you feel my heart
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,s.efil1)
	local e2=MakeEff(c,"E")
	e2:SetCode(EFFECT_MULTIPLE_SKULL)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCost(aux.bfgcost)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function s.efil1(c)
	return c:IsSetCard(0x45) or c:IsCustomType(CUSTOMTYPE_SKULL)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	Debug.Message(c:IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_RELEASE) and ec:GetFlagEffect(FLAGEFFECT_CUSTOMREASON)~=0
		and ec:GetFlagEffectLabel(FLAGEFFECT_CUSTOMREASON)&CUSTOMREASON_SKULL==CUSTOMREASON_SKULL)
	return c:IsReason(REASON_LOST_TARGET) and ec and ec:IsReason(REASON_RELEASE) and ec:GetFlagEffect(FLAGEFFECT_CUSTOMREASON)~=0
		and ec:GetFlagEffectLabel(FLAGEFFECT_CUSTOMREASON)&CUSTOMREASON_SKULL==CUSTOMREASON_SKULL
end
function s.tfil3(c,e,tp)
	return c:IsSetCard(0x45) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and s.tfil3(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(s.tfil3,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,s.tfil3,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocCount(tp,"M")<1 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end