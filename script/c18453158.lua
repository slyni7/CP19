--제미니: 아주 무서운 꿈을 꿨어
local m=18453158
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.cfil1(c)
	return c:IsSetCard("제미니:") and c:IsAbleToGraveAsCost() and (c:IsLoc("H") or c:IsFaceup())
end
function cm.tfun1(g,c,tp)
	g:AddCard(c)
	return Duel.IETarget(aux.TRUE,tp,"O","O",1,g)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=Duel.GMGroup(cm.cfil1,tp,"HO",0,c)
	if chkc then
		return chkc:IsOnField()
	end
	if chk==0 then
		return g:CheckSubGroup(cm.tfun1,1,1,c,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,cm.tfun1,false,1,2,c,tp)
	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(#sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.STarget(tp,aux.TRUE,tp,"O","O",1,#sg+1,c)
	Duel.SOI(0,CATEGORY_DESTROY,dg,#dg,0,0)
	if #sg+1-#dg>0 then
		Duel.SOI(0,CATEGORY_DRAW,nil,0,tp,#sg+1-#dg)
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		if ct>0 then
			aux.GeminiStarOperation(e,tp,2)
			if e:GetLabel()+1-ct>0 then
				Duel.BreakEffect()
				Duel.Draw(tp,e:GetLabel()+1-ct,REASON_EFFECT)
			end
		end
	end
end