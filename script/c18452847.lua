--헤븐 다크사이트 -설영-
local m=18452847
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","HM")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCountLimit(1,m)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
end
function cm.tfil1(c)
	return c:IsSetCard(0x2d9) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfil4(c)
	return c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsAbleToRemoveAsCost()
end
function cm.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.cfil4,tp,"G",0,1,nil)
			and ((c:IsLoc("H") and c:IsDiscardable()) or (c:IsLoc("M") and c:IsReleasable()))
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SMCard(tp,cm.cfil4,tp,"G",0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	if c:IsLoc("H") then
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	elseif c:IsLoc("M") then
		Duel.Release(c,REASON_COST)
	end
end
function cm.tfil4(c)
	return (c:IsAttack(0) or c:IsDefense(0) or c:IsType(TYPE_LINK)) and c:IsFaceup()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLoc("M") and cm.tfil4(chkc)
	end
	if chk==0 then
		return Duel.IETarget(cm.tfil4,tp,"M","M",1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,cm.tfil4,tp,"M","M",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end