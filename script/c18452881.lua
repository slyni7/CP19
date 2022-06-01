--검은 감비아
local m=18452881
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","F")
	e2:SetCode(EFFECT_EXTRA_SET_COUNT)
	e2:SetTargetRange(LSTN("H"),0)
	e2:SetTarget(cm.tar2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","F")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCountLimit(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","G")
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCost(aux.bfgcost)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function cm.tar2(e,c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
function cm.tfil3(c)
	return c:IsType(TYPE_NORMAL) and c:IsAbleToRemove()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLoc("M") and chkc:IsAbleToRemove()
	end
	if chk==0 then
		return Duel.IETarget(Card.IsAbleToRemove,tp,"M",0,1,nil) and Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.STarget(tp,Card.IsAbleToRemove,tp,"M",0,1,1,nil)
	Duel.SOI(0,CATEGORY_REMOVE,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local e1=MakeEff(c,"FC")
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(cm.oop31)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.oop31(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.tfil4(c)
	return c:IsCode(18452876) and c:IsAbleToHand()
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
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end