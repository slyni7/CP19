--모듈러성 정리
local m=18452795
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsType,TYPE_MODULE))
	local e2=MakeEff(c,"F","S")
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTR(1,1)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetCountLimit(1,m)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
end
function cm.con2(e)
	local c=e:GetHandler()
	return c:GetEquipTarget()
end
function cm.tar2(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	local ct=ec:GetEquipCount()
	return ec and c:GetLevel()>0 and ec:GetLevel()>0 and ec:GetLevel()+ct>=c:GetLevel() and ec:GetLevel()-ct<=c:GetLevel()
		and not c:IsType(TYPE_MODULE)
end
function cm.tfil3(c,e,tp)
	return c:IsType(TYPE_MODULE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil3(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil3,tp,"G",0,1,nil,e,tp) and Duel.GetLocCount(tp,"M")>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil3,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end