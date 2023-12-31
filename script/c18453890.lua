--vingt et un ~randez-vous~
local s,id=GetID()
function s.initial_effect(c)
	Pendulum.AddProcedure(c)
	local e6=MakeEff(c,"FTo","P")
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetD(id,1)
	e6:SetCL(1,id)
	WriteEff(e6,6,"NTO")
	c:RegisterEffect(e6)
	local e3=MakeEff(c,"FTo","P")
	e3:SetCode(EVENT_TO_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetD(id,2)
	e3:SetCL(1,{id,1})
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"FC","M")
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)
	local e1=MakeEff(c,"STo")
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1,{id,2})
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function s.tfil1(c)
	return c:IsSetCard("vingt et un") and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil1,tp,"D",0,1,nil)
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SMCard(tp,s.tfil1,tp,"D",0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.nfil3(c,tp)
	return c:IsSetCard("vingt et un") and c:IsControler(tp) and not c:IsReason(REASON_DRAW)
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.nfil3,1,nil,tp)
end
function s.tfil3(c)
	return c:IsAbleToHand() and c:IsCode(18453900)
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.ofil4,tp,"O",0,nil,tp)
	local sg=Duel.GMGroup(s.tfil3,tp,"D",0,nil)
	if chk==0 then
		return #g>0 and #sg>0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
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
		local tg=Duel.GMGroup(s.tfil3,tp,"D",0,nil)
		if #tg>0 then
			--[[Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local fc=tg:Select(tp,1,1,nil):GetFirst()]]--
			local fc=tg:GetFirst()
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
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GMGroup(s.ofil4,tp,"O",0,nil,tp)
	if rp~=tp and #g>0 and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0)) then
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
		local e3=MakeEff(c,"S","M")
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetValue(s.oval43)
		e3:SetLabelObject(re)
		e3:SetReset(RESET_CHAIN)
		c:RegisterEffect(e3)
	end
end
function s.oval43(e,re)
	return re==e:GetLabelObject()
end
function s.con6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc~=c and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard("vingt et un")
end
function s.tfil6(c)
	return c:IsAbleToHand() and c:IsCode(18453893)
end
function s.tar6(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GMGroup(s.ofil4,tp,"O",0,nil,tp)
	local sg=Duel.GMGroup(s.tfil6,tp,"D",0,nil)
	if chk==0 then
		return #g>0 and #sg>0
	end
	Duel.SOI(0,CATEGORY_TOHAND,nil,1,tp,"D")
end
function s.op6(e,tp,eg,ep,ev,re,r,rp)
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
		local tg=Duel.GMGroup(s.tfil6,tp,"D",0,nil)
		if #tg>0 then
			--[[Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local fc=tg:Select(tp,1,1,nil):GetFirst()]]--
			local fc=tg:GetFirst()
			Duel.SendtoHand(fc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,fc)
		end
	end
end