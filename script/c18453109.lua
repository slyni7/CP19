--인트로 옐로
local m=18453109
local cm=_G["c"..m]
function cm.initial_effect(c)
	Diffusion.AddProcCode(c,cm.pfil1,18453111,true)
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetTR("HM",0)
	e1:SetTarget(cm.tar1)
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
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
end
cm.custom_type=CUSTOMTYPE_DIFFUSION
function cm.pfil1(c)
	return c:IsCode(18453110)
end
function cm.tar1(e,c)
	return c:IsSetCard(0x2e2)
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
	return c:IsCode(18453111) and c:IsAbleToHand()
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
		return chkc:IsOnField() and chkc:IsControler(1-tp) and aux.disfilter1(chkc)
	end
	if chk==0 then
		return Duel.IETarget(aux.disfilter1,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.STarget(tp,aux.disfilter1,tp,0,"O",1,1,nil)
	Duel.SOI(0,CATEGORY_DISABLE,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end