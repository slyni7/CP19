--이펙트 스퀘어러
local m=18452813
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddSquareProcedure(c)
	local e1=MakeEff(c,"Qo","H")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DISABLE)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
end
cm.square_mana={ATTRIBUTE_WIND}
cm.custom_type=CUSTOMTYPE_SQUARE
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Group.CreateGroup()
	local chain=Duel.GetCurrentChain()
	for i=1,chain do
		local tg=Duel.GetChainInfo(i,CHAININFO_TARGET_CARDS)
		if tg then
			g:Merge(tg)
		end
	end
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField() and chkc:IsNegatable() and not g:IsContains(chkc)
	end
	if chk==0 then
		return Duel.IETarget(Card.IsNegatable,tp,0,"O",1,g)
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TARGET)
	local dg=Duel.SMCard(1-tp,Card.IsNegatable,tp,0,"O",1,1,g)
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=MakeEff(c,"S")
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end