--님프 메모리즈: 향기
function c99970067.initial_effect(c)

	--드로우 + 버림
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,99970067+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c99970067.target)
	e1:SetOperation(c99970067.activate)
	c:RegisterEffect(e1)
	
end

--드로우 + 버림
function c99970067.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
end
function c99970067.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==3 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(Card.IsDiscardable,p,LOCATION_HAND,0,nil)
		if g:GetCount()>1 and g:IsExists(Card.IsSetCard,1,nil,0xd35) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
			local sg1=g:FilterSelect(p,Card.IsSetCard,1,1,nil,0xd35)
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
			local sg2=g:Select(p,1,1,sg1:GetFirst())
			sg1:Merge(sg2)
			Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
		else
			local sg=Duel.GetFieldGroup(p,LOCATION_HAND,0)
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	end
end
