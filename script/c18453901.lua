--vingt et un ~cielo~
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_CHAINING)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
end
function s.nfil1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard("vingt et un") and c:IsFaceup()
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IEMCard(s.nfil1,tp,"O",0,1,nil) and rp~=tp and Duel.IsChainNegatable(ev)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SOI(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		Duel.SOI(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function s.ofil1(c,tp)
	return c:IsSetCard("vingt et un")
		and (not c:IsDisabled() or (c:IsAbleToHand() and Duel.IsPlayerAffectedByEffect(tp,18453900)))
		and c:IsFaceup()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) then
		if rc:IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
		if c:IsRelateToEffect(e) then
			local g=Duel.GMGroup(s.ofil1,tp,"O",0,c,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=g:Select(tp,0,1,nil)
			if not tc then
				return
			end
			local tc=sg:GetFirst()
			if tc:IsAbleToHand() and Duel.IsPlayerAffectedByEffect(tp,18453900) and (tc:IsDisabled() or Duel.SelectYesNo(tp,aux.Stringid(18453900,1))) then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			else
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
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
		end
	end
end