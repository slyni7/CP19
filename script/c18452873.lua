--´©¸¥ ´«ÀÇ ½ÖÈ²Åä·æ
local m=18452873
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeRep(c,18452865,2,true,true)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","E")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"STo")
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
cm.material_setcode="´©¸¥ ´«"
function cm.val1(e,se,sp,st)
	return st&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function cm.nfil21(c,sc)
	return c:IsCode(18452865) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function cm.nfil22(c,sc,tp)
	return c:IsSummonType(SUMMON_TYPE_NORMAL) and c:GetTurnID()==Duel.GetTurnCount() and c:IsSetCard("´©¸¥ ´«")
		and c:IsAbleToRemoveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function cm.con2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IEMCard(cm.nfil21,tp,"H",0,1,nil,c) and Duel.IEMCard(cm.nfil22,tp,"M",0,1,nil,c,tp)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SMCard(tp,cm.nfil21,tp,"H",0,1,1,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SMCard(tp,cm.nfil22,tp,"M",0,1,1,nil,c,tp)
	local mg=Group.CreateGroup()
	mg:Merge(g1)
	mg:Merge(g2)
	c:SetMaterial(mg)
	Duel.SendtoGrave(g1,REASON_COST)
	Duel.Remove(g2,POS_FACEUP,REASON_COST)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LSTN("M")) and rp==1-tp and r&REASON_DESTROY>0
end
function cm.tfil3(c)
	return c:IsCode(18452865) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil3(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil3,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil3,tp,"G",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end