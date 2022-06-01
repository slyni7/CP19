--제미니: 누군가 누군가 도와줘
local m=18453160
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"Qo","F")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_TOGRAVE,nil,0,tp,"H")
end
function cm.ofil1(c)
	return c:IsSetCard("제미니:") and c:IsAbleToGrave() and (c:IsLoc("H") or c:IsFaceup()) and not c:IsCode(m)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		aux.GeminiStarOperation(e,tp,1)
		if Duel.IsPlayerCanDraw(tp,1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SMCard(tp,cm.ofil1,tp,"HO",0,0,1,nil)
			if #g>0 and Duel.SendtoGrave(g,REASON_EFFECT)>0 then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end
function cm.cfil2(c)
	return c:IsSetCard("제미니:") and c:IsAbleToGraveAsCost() and (c:IsLoc("H") or c:IsFaceup())
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IEMCard(cm.cfil2,tp,"HO",0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,cm.cfil2,tp,"HO",0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	if g:IsContains(c) then
		e:SetLabel(0)
	else
		e:SetLabel(10000)
	end
end
function cm.tfil2(c)
	return c:IsSetCard("제미니:") and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(cm.tfil2,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) or e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SMCard(tp,cm.tfil2,tp,"D",0,1,1,nil)
		if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,g)
			aux.GeminiStarOperation(e,tp,2)
		end
	end
end