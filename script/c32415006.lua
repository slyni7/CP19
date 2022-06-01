--크리티컬 퀘스천
local m=32415006
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost1)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.cfil1(c,tp,g,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=g:IsExists(cm.cfil1,1,sg,tp,g,sg)
	else
		res=cm.cfun1(tp,sg)
	end
	sg:RemoveCard(c)
	return res
end
function cm.cfun1(tp,g)
	local fc=g:GetFirst()
	local nc=g:GetNext()
	if not fc:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_LIGHT+ATTRIBUTE_WIND) then
		fc,nc=nc,fc
	end
	return g:GetClassCount(Card.GetLevel)==1 and g:GetClassCount(Card.GetLocation)==2
		and fc:GetLevel()<Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)+2
		and ((fc:IsAttribute(ATTRIBUTE_FIRE) and nc:IsAttribute(ATTRIBUTE_WATER))
			or (fc:IsAttribute(ATTRIBUTE_LIGHT) and nc:IsAttribute(ATTRIBUTE_DARK))
			or (fc:IsAttribute(ATTRIBUTE_WIND) and nc:IsAttribute(ATTRIBUTE_EARTH)))
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local sg=Group.CreateGroup()
	if chk==0 then
		return g:IsExists(cm.cfil1,1,nil,tp,g,sg)
	end
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=g:FilterSelect(tp,cm.cfil1,1,1,sg,tp,g,sg)
		sg:Merge(tg)
	end
	local lv=sg:GetFirst():GetLevel()
	Duel.SendtoGrave(sg,REASON_COST)
	e:SetLabel(lv)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_HAND)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		local lv=e:GetLabel()
		local g=Duel.GetDecktopGroup(tp,lv)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			g:Sub(sg)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	Duel.RegisterEffect(e2,tp)
end