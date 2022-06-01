--속도와 폭주의 한복판으로
local m=18452936
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetCategory(CATEGORY_EQUIP)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S")
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(aux.TargetBoolFunction(Card.IsSetCard,0x2dc))
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"E")
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetValue(2000)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"E")
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetValue(4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"E")
	e5:SetCode(m)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"STo")
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e6:SetCountLimit(1,m)
	WriteEff(e6,6,"TO")
	c:RegisterEffect(e6)
end
function cm.tfil1(c)
	return c:IsFaceup() and c:IsSetCard(0x2dc)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("M") and cm.tfil1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil1,tp,"M","M",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.STarget(tp,cm.tfil1,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_EQUIP,c,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function cm.tfil6(c,e,tp,ec)
	return c:IsSetCard(0x2dc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ec:CheckEquipTarget(c)
end
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil6(chkc,e,tp,c)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.GetLocCount(tp,"S")>0 and Duel.IETarget(cm.tfil6,tp,"G",0,1,nil,e,tp,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil6,tp,"G",0,1,1,nil,e,tp,c)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0
		and c:IsRelateToEffect(e) and Duel.GetLocCount(tp,"S")>0 and c:CheckEquipTarget(tc) then
		Duel.Equip(tp,c,tc)
	end
end