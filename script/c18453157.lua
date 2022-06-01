--하늘을 넘어 이끌리는 제미니: 야
local m=18453157
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.pfil1,nil,2,2)
	aux.EnableReverseDualAttribute(c)
	local e1=MakeEff(c,"S","M")
	e1:SetCode(EFFECT_CHANGE_RANK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(cm.con1)
	e1:SetValue(3)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(2100)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(2100)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","M")
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCountLimit(1)
	WriteEff(e4,4,"NCTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"Qo","M")
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCountLimit(1)
	WriteEff(e5,4,"N")
	WriteEff(e5,5,"CTO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"STo")
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e6:SetCategory(CATEGORY_TOHAND)
	WriteEff(e6,6,"TO")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"S","M")
	e7:SetCode(EFFECT_SUMMONABLE_CARD)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetCondition(cm.con1)
	c:RegisterEffect(e7)
	local e8=MakeEff(c,"S","M")
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCondition(cm.con8)
	e8:SetValue(cm.val8)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EFFECT_UPDATE_DEFENSE)
	e9:SetValue(cm.val9)
	c:RegisterEffect(e9)
end
function cm.pfil1(c)
	return c:GetOriginalLevel()==9
end
function cm.con1(e)
	local c=e:GetHandler()
	return not c:IsDualState()
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDisabled() or not c:IsDualState()
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.tfil4(c)
	return c:IsSetCard("제미니:") and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil4,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil4,tp,"D",0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		aux.GeminiStarOperation(e,tp,1)
	end
end
function cm.cfil5(c)
	return c:IsSetCard("제미니:") and c:IsAbleToGraveAsCost() and (c:IsFaceup() or c:IsLoc("H"))
end
function cm.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.cfil5,tp,"HO",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.cfil5,tp,"HO",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,0,"O",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		aux.GeminiStarOperation(e,tp,1)
	end
end
function cm.tfil6(c)
	return c:IsSetCard("제미니:") and c:IsAbleToHand()
end
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("G") and cm.tfil6(chkc) and chkc~=c
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil6,tp,"G",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil6,tp,"G",0,1,1,c)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tc)
		aux.GeminiStarOperation(e,tp,1)
	end
end
function cm.con8(e)
	local c=e:GetHandler()
	return c:IsDualState() and not c:IsDisabled()
end
function cm.val8(e,c)
	return math.ceil(c:GetBaseAttack()/2)
end
function cm.val9(e,c)
	return math.ceil(c:GetBaseDefense()/2)
end