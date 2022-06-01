--몽실몽실 익스큐션
local m=112401249
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SEARCH)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tar2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_DECK)
	e3:SetCost(cm.tkcost)
	e3:SetTarget(cm.rettg)
	e3:SetOperation(cm.retop)
	c:RegisterEffect(e3)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1000000)
	return true
end
function cm.tfun2(g,tp)
	if not g:IsExists(cm.tfil21,1,nil,tp) then
		return false
	end
	local sg=Duel.GetMatchingGroup(cm.tfil22,tp,LOCATION_DECK,0,nil)
	if #g>sg:GetClassCount(Card.GetCode) then
		return false
	end
	local og=g:Filter(Card.IsControler,nil,1-tp)
	if #og>0 then
		if not Duel.IsPlayerCanDraw(1-tp,#og) then
			return false
		end
	end
	return true
end
function cm.tfil21(c,tp)
	return c:IsSetCard(0xfe1) and c:IsLocation(LOCATION_ONFIELD+LOCATION_HAND) and (c:IsControler(tp) or c:IsFaceup())
end
function cm.tfil22(c)
	return c:IsSetCard(0xfe1) and c:IsAbleToHand()
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.SetChainLimit(cm.chlimit)
	local g=Duel.GetMatchingGroup(Card.IsReleaseable,tp,LOCATION_ONFIELD+LOCATION_HAND,LOCATION_ONFIELD+LOCATION_HAND,nil)
	if chk==0 then
		if e:GetLabel()~=1000000 then
			return false
		end
		e:SetLabel(0)
		return g:CheckSubGroup(cm.tfun2,1,#g,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:SelectSubGroup(tp,cm.tfun2,false,1,#g,tp)
	local og=rg:Filter(Card.IsControler,nil,1-tp)
	e:SetLabel((#rg<<16)+#og)
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,#rg,tp,LOCATION_DECK)
	if #og>0 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,#og)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	local ct1=label>>16
	local ct2=label&0xffff
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(cm.tfil22,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=ct1 then
		local sg=Group.CreateGroup()
		for i=1,ct1 do
			local tg=g:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			sg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	if ct2>0 then
		Duel.Draw(1-tp,ct2,REASON_EFFECT)
	end
end
function cm.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,-2,REASON_EFFECT)
	end
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.SetChainLimit(cm.chlimit)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end