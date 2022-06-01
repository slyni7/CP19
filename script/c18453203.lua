--Fresh Arom@ir
local m=18453203
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"FC","S")
	e2:SetCode(EVENT_ADJUST)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"FC","S")
	e3:SetCode(EVENT_RECOVER)
	e3:SetCountLimit(1)
	WriteEff(e3,3,"NO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","S")
	e4:SetCode(EVENT_ADJUST)
	e4:SetCountLimit(1)
	WriteEff(e4,4,"NO")
	c:RegisterEffect(e4)
end
function cm.nfil2(c)
	return c:IsSetCard(0x2e6) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IEMCard(cm.nfil2,tp,"M",0,1,nil)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Recover(tp,500,REASON_EFFECT)
end
function cm.nfil3(c)
	return c:IsSetCard(0x2e6) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil3,tp,"D",0,1,nil)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,cm.nfil3,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.nfil4(c)
	return c:IsSetCard(0x2e6) and c:IsFaceup() and c:GetLevel()+c:GetRank()+c:GetLink()>0
end
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(cm.nfil4,tp,"M",0,1,nil)
end
function cm.ofun4(c)
	return c:GetLevel()+c:GetRank()+c:GetLink()
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GMGroup(cm.nfil4,tp,"M",0,nil)
	local rec=g:GetSum(cm.ofun4)*100
	Duel.Recover(tp,rec,REASON_EFFECT)
end
