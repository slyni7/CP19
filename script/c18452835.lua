--헤븐 다크사이트 -민영-
local m=18452835
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil11(c,tp)
	return c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsAbleToHand() and not c:IsCode(m) and Duel.IEMCard(cm.tfil12,tp,"D",0,1,c,c:GetCode())
end
function cm.tfil12(c,code)
	return c:IsCode(code) and c:IsAttack(0) and c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil11,tp,"D",0,1,nil,tp)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,1,tp,"D")
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SMCard(tp,cm.tfil11,tp,"D",0,1,1,nil,tp)
	local tc=g1:GetFirst()
	if not tc then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SMCard(tp,cm.tfil12,tp,"D",0,1,1,tc,tc:GetCode())
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
	Duel.SendtoGrave(g2,REASON_EFFECT)
end