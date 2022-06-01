--달이 차오른다
local m=18453036
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"L",nil,aux.FilterBoolFunction(Card.IsPosition,POS_FACEDOWN_DEFENSE),
		aux.FilterBoolFunction(Card.IsPosition,POS_FACEUP_ATTACK))
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_LINK_FACEDOWN_SUB)
	e1:SetTR("M","M")
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tar1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCondition(cm.con1)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"FTo","M")
	e5:SetCode(EVENT_FLIP)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	WriteEff(e5,5,"NTO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"Qo","M")
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	WriteEff(e6,6,"NCTO")
	c:RegisterEffect(e6)
end
function cm.nfil1(c)
	return c:IsCode(18453034) and (c:IsLoc("G") or c:IsFaceup())
end
function cm.con1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IEMCard(cm.nfil1,tp,"OG",0,1,nil)
end
function cm.tar1(e,c)
	return c:IsType(TYPE_LINK)
end
function cm.tfil2(c)
	return c:IsCode(14087893) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not eg:IsContains(c)
end
function cm.tfil5(c)
	return c:IsCode(14087893,35480699,31834488) and c:IsSSetable()
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil5,tp,"D",0,1,nil) and Duel.GetLocCount(tp,"S")>0
	end
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocCount(tp,"S")
	if ft<1 then
		return
	end
	local ct=#eg
	if ft>ct then
		ft=ct
	end
	local g=Duel.GMGroup(cm.tfil5,tp,"D",0,nil)
	if #g<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ft)
	Duel.SSet(tp,sg)
end
function cm.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function cm.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	Duel.ChangePosition(c,POS_FACEUP_ATTACK)
end
function cm.tfil6(c)
	return c:IsCode(12923641) and c:IsAbleToHand()
end
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil6,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil6,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end