--vingt et un ~arc-en-ciel~
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"A")
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	WriteEff(e1,1,"O")
	c:RegisterEffect(e1)
	local e6=MakeEff(c,"FTo","S")
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetD(id,1)
	e6:SetCL(1)
	WriteEff(e6,6,"NTO")
	c:RegisterEffect(e6)
	local e3=MakeEff(c,"FTo","S")
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetD(id,2)
	e3:SetCL(1)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
end
function s.ofil1(c)
	return (c:IsType(TYPE_TRAP) or c:IsType(TYPE_QUICKPLAY)) and c:IsSetCard("vingt et un") and c:IsAbleToHand()
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SMCard(tp,s.ofil1,tp,"D",0,0,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function s.nfil3(c,tp)
	return c:IsSetCard("vingt et un") and c:IsControler(tp) and not c:IsReason(REASON_DRAW)
		and c:IsType(TYPE_PENDULUM)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil3,1,nil,tp)
end
function s.tfil3(c)
	return c:IsAbleToHand() and c:IsSetCard("vingt et un") and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.ofil4,tp,"O",0,nil,tp)
	local sg=Duel.GMGroup(s.tfil3,tp,"E",0,nil)
	if chk==0 then
		return #g>0 and #sg>0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"E")
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GMGroup(s.ofil4,tp,"O",0,nil,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local sg=g:Select(tp,1,1,nil)
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
		local tg=Duel.GMGroup(s.tfil3,tp,"E",0,nil)
		if #tg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local fc=tg:Select(tp,1,1,nil):GetFirst()
			Duel.SendtoHand(fc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,fc)
		end
	end
end
function s.ofil4(c,tp)
	return c:IsSetCard("vingt et un")
		and (not c:IsDisabled() or (c:IsAbleToHand() and Duel.IsPlayerAffectedByEffect(tp,18453900)))
		and c:IsFaceup()
end
function s.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc:IsLoc("P") and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard("vingt et un")
end
function s.tfil61(c,tp)
	return c:IsSetCard("vingt et un") and c:IsType(TYPE_PENDULUM)
		and not Duel.IEMCard(s.tfil62,tp,"OE",0,1,nil,c:GetCode())
end
function s.tfil62(c,code)
	return c:IsFaceup() and c:IsCode(code)
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GMGroup(s.tfil61,tp,"D",0,nil,tp)
	if chk==0 then
		return #sg>0
	end
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tg=Duel.GMGroup(s.tfil61,tp,"D",0,nil,tp)
	if #tg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local fc=tg:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoExtraP(fc,nil,REASON_EFFECT)
	end
end