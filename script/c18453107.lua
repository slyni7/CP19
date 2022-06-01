--인트로 레드
local m=18453107
local cm=_G["c"..m]
function cm.initial_effect(c)
	Diffusion.AddProcCode(c,cm.pfil1,18453109,true)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FTo","M")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
cm.custom_type=CUSTOMTYPE_DIFFUSION
function cm.pfil1(c)
	return c:IsCode(18453108)
end
function cm.tfil1(c,e,tp)
	return c:IsSetCard(0x2e2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(m)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.tfil1,tp,"H",0,1,nil,e,tp)
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
function cm.nfil2(c,tp)
	return c:IsSetCard(0x2e2) and c:IsFaceup() and  c:IsControler(tp)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:IsContains(c) then
		return false
	end
	local g=eg:Filter(cm.nfil2,nil,tp)
	if #g<1 then
		return false
	end
	local tc=g:GetFirst()
	local label=0
	while tc do
		if tc:IsSummonType(SUMMON_TYPE_DIFFUSION) then
			label=label|0x1
		else
			label=label|0x2
		end
		tc=g:GetNext()
	end
	e:SetLabel(label)
	return true
end
function cm.tfil21(c)
	return c:IsCode(18453109) and c:IsAbleToHand()
end
function cm.tfil22(c)
	return c:IsCode(122400000) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local label=e:GetLabel()
	local b1=label&0x1==0x1 and Duel.IEMCard(cm.tfil21,tp,"D",0,1,nil)
	local b2=label&0x2==0x2 and Duel.IEMCard(cm.tfil22,tp,"DG",0,1,nil)
	if chk==0 then
		return b1 or b2
	end
	if label==0x1 then
		Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	elseif label==0x2 then
		Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DG")
	elseif label==0x3 then
		Duel.SOI(0,CATEGORY_TOHAND,nil,2,tp,"DG")
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=e:GetLabel()
	if label&0x1==0x1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil21,tp,"D",0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetLabel(tc:GetCode())
			e1:SetTarget(cm.otar21)
			Duel.RegisterEffect(e1,tp)
		end
	end
	if label&0x2==0x2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil22,tp,"DG",0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetLabel(tc:GetCode())
			e1:SetTarget(cm.otar21)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cm.otar21(e,c,tp,re)
	return c:IsCode(e:GetLabel()) and re and re:GetHandler():IsCode(m)
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_DIFFUSION)
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()	
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,0,"O",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end