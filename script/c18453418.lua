--어린 날의 꿈처럼 마치 기적처럼
local m=18453418
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetCost(aux.RemainFieldCost)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"S","S")
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetValue(CARD_TIME_CAPSULE)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e3:SetCL(1)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"S")
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
end
cm.listed_names={CARD_TIME_CAPSULE}
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(Card.IsAbleToRemove,tp,"D",0,1,nil,tp,POS_FACEDOWN)
	end
	Duel.SOI(0,CATEGORY_REMOVE,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,Card.IsAbleToRemove,tp,"D",0,1,1,nil,tp,POS_FACEDOWN)
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)~=0 then
		if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE)
			and not c:IsStatus(STATUS_LEAVE_CONFIRMED) then
			tc:RegisterFlagEffect(CARD_TIME_CAPSULE,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=MakeEff(c,"S","S")
			e1:SetCode(EFFECT_TIME_CAPSULE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetLabelObject(tc)
			c:RegisterEffect(e1)
		end
	else
		if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) and not c:IsStatus(STATUS_LEAVE_CONFIRMED) then
			c:CancelToGrave(false)
		end
	end
end
function cm.tfil3(c)
	return c:IsCode(CARD_TIME_CAPSULE) and c:IsFaceup()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return cm.tfil3(chkc) and chkc:IsControler(tp) and chkc:IsOnField() and chkc~=c
	end
	if chk==0 then
		return c:IsAbleToHand() and Duel.IETarget(cm.tfil3,tp,"O",0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,cm.tfil3,tp,"O",0,1,1,c)
	Duel.SOI(0,CATEGORY_TOHAND,c,0,tp,"R")
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local ce=tc:IsHasEffect(EFFECT_TIME_CAPSULE)
		local cc=nil
		if ce then
			cc=ce:GetLabelObject()
		end
		if Duel.Destroy(tc,REASON_EFFECT)>0 and cc and cc:IsAbleToHand()
			and cc:GetFlagEffect(CARD_TIME_CAPSULE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.SendtoHand(cc,nil,REASON_EFFECT)
		end
	end
end