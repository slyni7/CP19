--제미니: 떠들썩한 낮도 안타까운 밤도
local m=18453162
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnableReverseDualAttribute(c)
	local e1=MakeEff(c,"S","HM")
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCondition(cm.con1)
	e1:SetValue(3)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetRange(LSTN("M"))
	e2:SetValue(900)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(2100)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","H")
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.con4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"STo")
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetCountLimit(1,m+1)
	WriteEff(e5,5,"TO")
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"I","G")
	e6:SetCategory(CATEGORY_TOGRAVE)
	e6:SetCountLimit(1,m+2)
	WriteEff(e6,6,"CTO")
	c:RegisterEffect(e6)
	local e7=MakeEff(c,"S")
	e7:SetCode(EFFECT_DIRECT_ATTACK)
	e7:SetCondition(cm.con7)
	c:RegisterEffect(e7)
end
function cm.con1(e)
	local c=e:GetHandler()
	return not c:IsDualState()
end
function cm.con4(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.GetFieldGroupCount(tp,LSTN("M"),0)<=Duel.GetFieldGroupCount(tp,0,LSTN("M"))
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp,c)
	aux.GeminiStarOperation(e,tp,1)
end
function cm.tfil5(c)
	return c:IsSetCard("제미니:") and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil5,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil5,tp,"D",0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		aux.GeminiStarOperation(e,tp,1)
	end
end
function cm.cost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function cm.tfil6(c)
	return c:IsSetCard("제미니:") and c:IsAbleToGrave() and not c:IsCode(m)
end
function cm.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil6,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.tfil6,tp,"D",0,1,1,nil)
	if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
		aux.GeminiStarOperation(e,tp,1)
	end
end
function cm.con7(e)
	local c=e:GetHandler()
	return c:IsDualState() and not c:IsDisabled()
end