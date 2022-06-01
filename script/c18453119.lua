--½ºÅ¾ À¯Â¡ F(Ç»Àü)
local m=18453119
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"I","G")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"F","H")
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"F","M")
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTR("M","M")
	e3:SetTarget(cm.tar3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"F","M")
	e4:SetCode(EFFECT_DISABLE)
	e4:SetTR("M","M")
	e4:SetTarget(cm.tar4)
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","M")
	e5:SetCode(EFFECT_DISABLE)
	e5:SetTR("S","S")
	e5:SetTarget(cm.tar5)
	c:RegisterEffect(e5)
	local e6=MakeEff(c,"FC","M")
	e6:SetCode(EVENT_CHAIN_SOLVING)
	WriteEff(e6,6,"O")
	c:RegisterEffect(e6)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function cm.tfil1(c)
	return c:IsSetCard("½ºÅ¾ À¯Â¡") and c:IsAbleToHand() and not c:IsCode(m)
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
function cm.nfil2(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function cm.con2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocCount(tp,"M")>0 and Duel.IEMCard(cm.nfil2,tp,"M","M",1,nil)
end
function cm.tar3(e,c)
	return c:IsType(TYPE_FUSION)
end
function cm.tar4(e,c)
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT==TYPE_EFFECT)
		and c:IsType(TYPE_FUSION)
end
function cm.tar5(e,c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x46)
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local rc=re:GetHandler()
	if tl&LSTN("S")>0 and re:IsActiveType(TYPE_SPELL) and rc:IsSetCard(0x46) then
		Duel.NegateEffect(ev)
	end
end