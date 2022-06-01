--신세계의 정령
local m=18452784
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,aux.dabcheck)
	local e1=MakeEff(c,"F","G")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	local e2=MakeEff(c,"FG","M")
	e2:SetTR("G",0)
	e2:SetTarget(cm.tar2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FTo","M")
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"I","G")
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetCost(aux.bfgcost)
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCountLimit(1,99234526)
	local e6=e2:Clone()
	e6:SetTarget(aux.TargetBoolFunction(Card.IsCode,99234526))
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetCountLimit(1,61901281)
	local e8=e2:Clone()
	e8:SetTarget(aux.TargetBoolFunction(Card.IsCode,61901281))
	e8:SetLabelObject(e7)
	c:RegisterEffect(e8)
end
function cm.nfil1(c,code)
	if not c:IsAbleToRemoveAsCost() then
		return false
	end
	if code==13522325 or code==74823665 then
		return c:IsAttribute(ATTRIBUTE_FIRE)
	end
	if code==73001017 or code==12800777 then
		return c:IsAttribute(ATTRIBUTE_WIND)
	end
	if code==40916023 or code==218704 then
		return c:IsAttribute(ATTRIBUTE_WATER)
	end
	if code==47606319 or code==76305638 then
		return c:IsAttribute(ATTRIBUTE_EARTH)
	end
	if code==99234526 or code==48596760 then
		return c:IsAttribute(ATTRIBUTE_DARK)
	end
	if code==61901281 or code==17257342 then
		return c:IsAttribute(ATTRIBUTE_LIGHT)
	end
	if code==18452771 then
		return ((c:IsLevel(4) or c:IsRank(4)) and c:IsSetCard("정령") and not c:IsSummonableCard())
			or c:IsCode(47606319,61901281,99234526,73001017,218704,74823665)
	end
	return false
end
function cm.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	local ocode=c:GetOriginalCode()
	local ct=ocode==218704 and 2 or 1
	return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.nfil1,tp,"G",0,ct,c,ocode)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local ocode=c:GetOriginalCode()
	local ct=ocode==218704 and 2 or 1
	local g=Duel.SMCard(tp,cm.nfil1,tp,"G",0,ct,ct,c,ocode)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.tar2(e,c)
	return (c:IsLevel(4) and c:IsSetCard("정령") and not c:IsSummonableCard())
		or c:IsCode(47606319,73001017,218704,74823665,18452771)
end
function cm.nfil3(c)
	return not c:IsSummonableCard() and c:GetSummonLocation()&LSTN("HG")>0
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil3,1,nil)
end
function cm.tfil3(c)
	return c:IsCode(18452785,18452787) and c:IsAbleToHand()
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LSTN("H"),0)>0 and Duel.IEMCard(cm.tfil3,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SOI(0,CATEGORY_TOAHND,nil,1,tp,"D")
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil3,tp,"D",0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.tfil4(c)
	return c:IsCode(18452788) and c:IsAbleToHand()
end
function cm.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil4,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOAHND,nil,1,tp,"D")
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil4,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end