--라이네 클라이네
local m=18452890
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.pfil1,1,1)
	local e1=MakeEff(c,"S","MG")
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(CARD_EINE_KLEINE)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	WriteEff(e2,2,"NTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","M")
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetCL(1)
	WriteEff(e3,3,"CTO")
	c:RegisterEffect(e3)
end
function cm.pfil1(c)
	return c:IsLinkCode(CARD_EINE_KLEINE) and not c:IsType(TYPE_LINK)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tfil2(c)
	return c:IsCode(CARD_EINE_KLEINE) and c:IsAbleToHand() and c:GetAttack()>1500
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLoc("G") and chkc:IsControler(tp) and cm.tfil2(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil2,tp,"G",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.STarget(tp,cm.tfil2,tp,"G",0,1,1,nil)
	Duel.SOI(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.cfil3(c)
	return c:IsCode(CARD_EINE_KLEINE) and c:IsAbleToRemoveAsCost()
end
function cm.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetReleaseGroup(tp):Filter(Card.IsCode,nil,CARD_EINE_KLEINE)
	if c:IsHasEffect(EFFECT_EINE_KLEINE) then
		local rg=Duel.GMGroup(cm.cfil3,tp,"G",0,nil)
		g:Merge(rg)
	end
	if chk==0 then
		return #g>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tg=g:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if tc:IsLoc("G") then
		Duel.Remove(tg,POS_FACEUP,REASON_COST)
		local te=c:IsHasEffect(EFFECT_EINE_KLEINE)
		te:UseCountLimit(tp)
	else
		Duel.Release(tg,REASON_COST)
	end
end
function cm.tfil3(c)
	return c:IsCode(18452963) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil3,tp,"DG",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"DG")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil3,tp,"DG",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end