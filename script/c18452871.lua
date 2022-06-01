--´©¸¥ ´«ÀÇ ¾ÆÅä·æ
local m=18452871
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.nfil1(c)
	return c:IsCode(18452865) and c:IsAbleToGraveAsCost()
end
function cm.con1(e,c,minc)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return minc<1 and c:IsLevelAbove(5) and Duel.GetLocCount(tp,"M")>0
		and Duel.IEMCard(cm.nfil1,tp,"H",0,1,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.nfil1,tp,"H",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=MakeEff(c,"FTo","M")
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0xfe0000)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(cm.ocon11)
	e1:SetTarget(cm.otar11)
	e1:SetOperation(cm.oop11)
	c:RegisterEffect(e1)
end
function cm.ocon11(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()+1
end
function cm.otfil11(c,e,tp)
	return c:IsCode(18452865) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.otar11(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.otfil11(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IETarget(cm.otfil11,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.otfil11,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.oop11(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end