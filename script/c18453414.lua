--투명한 유리구슬처럼 보이지만
local m=18453414
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","R")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
end
cm.listed_names={CARD_TIME_CAPSULE}
function cm.tfil1(c)
	return c:IsCode(CARD_TIME_CAPSULE) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"DG",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DG")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"DG",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFacedown()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:GetFlagEffect(m)==0
	end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
end
function cm.tfil2(c)
	return c:IsCode(CARD_TIME_CAPSULE) and c:IsFaceup()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return cm.tfil2(chkc) and chkc:IsControler(tp) and chkc:IsOnField()
	end
	if chk==0 then
		return c:IsAbleToHand() and Duel.IETarget(cm.tfil2,tp,"O",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,cm.tfil2,tp,"O",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,c,1,0,0)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,c)
		if tc:IsRelateToEffect(e) then
			local ce=tc:IsHasEffect(EFFECT_TIME_CAPSULE)
			local cc=nil
			if ce then
				cc=ce:GetLabelObject()
			end
			if Duel.Destroy(tc,REASON_EFFECT)>0 and cc and cc:IsAbleToHand()
				and cc:GetFlagEffect(CARD_TIME_CAPSULE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,00)) then
				Duel.SendtoHand(cc,nil,REASON_EFFECT)
			end
		end
	end
end