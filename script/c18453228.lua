--프린세스 로드(Make Princess Great Again)
local m=18453228
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","S")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetCL(1,m)
	e1:SetLabelObject(e2)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","S")
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(cm.tar3)
	e3:SetValue(cm.val3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
function cm.ofil1(c)
	return c:IsCode(18453227) and c:IsAbleToGrave()
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SMCard(tp,cm.ofil1,tp,"D",0,0,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
			local te=e:GetLabelObject()
			te:UseCountLimit(tp)
		end
	end
end
function cm.tfil2(c,e,tp)
	return c:IsCode(18453227) and (c:IsAbleToHand() or
		(Duel.GetLocCount(tp,"M")>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"G",0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,nil,e,tp)
	Duel.SOI(0,CATEGORY_SPECIAL_SUMMON,g,0,0,0)
	Duel.SOI(0,CATEGORY_TOHAND,g,0,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local th=tc:IsAbleToHand()
		local sp=Duel.GetLocCount(tp,"M")>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		local op=0
		if th and sp then
			op=Duel.SelectOption(tp,1190,1152)
		elseif th then
			op=0
		else
			op=1
		end
		if op==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function cm.vfil3(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLoc("M") and c:IsCode(18453227)
		and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT)) and not c:IsReason(REASON_REPLACE)
end
function cm.tfil3(c)
	return c:IsAbleToDeck() and c:IsFaceup() and c:GetType()&TYPE_TRAP+TYPE_CONTINUOUS==TYPE_TRAP+TYPE_CONTINUOUS
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(cm.vfil3,1,nil,tp) and Duel.IEMCard(cm.tfil3,tp,"S",0,1,nil)
	end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.val3(e,c)
	local tp=e:GetHandlerPlayer()
	return cm.vfil3(c,tp)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"S",0,1,1,nil)
	Duel.Hint(HINT_CARD,0,m)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_REPLACE)
end