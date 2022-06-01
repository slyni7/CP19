--μ(마이크로) 약사
local m=11111115
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.pfil1,nil,nil,nil,1,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tar1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.pfil1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x1f5)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToHand()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	local tc=g:GetFirst()
	if tc:GetAttack()~=tc:GetBaseAttack() then
		local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc)
		if #sg>0 then
			Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,0,0)
		end
	end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local res=tc:GetAttack()~=tc:GetBaseAttack()
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and res then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0,1,nil)
			if #g>0 then
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end
		end
	end
end