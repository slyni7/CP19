--스퀘어플레이크
local m=18452831
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"I","S")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","S")
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.tfil2(c)
	return c:IsSetCard(0x2d7) and c:IsLevel(1) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local e1=MakeEff(c,"F")
		e1:SetCode(EFFECT_CANNOT_TO_HAND)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tc:GetAttribute())
		e1:SetTarget(cm.otar21)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.otar21(e,c,tp,re)
	return c:IsAttribute(e:GetLabel()) and re and re:GetHandler():IsCode(m)
end
function cm.nfil3(c,tp)
	return c:IsFaceup() and c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsControler(tp)
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil3,1,nil,tp)
end
function cm.tfil31(c,tp,eg)
	return cm.nfil3(c,tp) and eg:IsContains(c) and Duel.IEMCard(cm.tfil32,tp,"D",0,1,nil,c)
end
function cm.tfil32(c,tc)
	return c:IsCustomType(CUSTOMTYPE_SQUARE) and c:IsAbleToHand() and (c:IsHasSquareMana(tc:GetAttribute()) or tc:IsHasSquareMana(c:GetAttribute()))
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil31,tp,"M",0,1,nil,tp,eg)
	end
	if #eg==1 then
		Duel.SetTargetCard(eg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FAECUP)
		Duel.STarget(tp,cm.tfil31,tp,"M",0,1,1,nil,tp,eg)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil32,tp,"D",0,1,1,nil,tc)
		local sc=g:GetFirst()
		if sc then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local e1=MakeEff(c,"F")
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			e1:SetLabel(sc:GetAttribute())
			e1:SetTarget(cm.otar21)
			Duel.RegisterEffect(e1,tp)
		end
	end
end