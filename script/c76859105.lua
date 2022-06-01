--Angel Notes - ÇÃ·Î¿ì
function c76859105.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,76859105+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c76859105.tg1)
	e1:SetOperation(c76859105.op1)
	c:RegisterEffect(e1)
end
function c76859105.tfilter1(c)
	return c:IsSetCard(0x2c8) and c:IsFaceup()
end
function c76859105.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c76859105.tfilter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c76859105.tfilter1,tp,LOCATION_MZONE,0,1,nil)
	end
	local g=Duel.SelectTarget(tp,c76859105.tfilter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c76859105.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(76859105,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetLabel(fid)
		e1:SetLabelObject(tc)
		e1:SetOperation(c76859105.op11)
		Duel.RegisterEffect(e1,tp)
	end
end
function c76859105.ofilter11(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c76859105.op11(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if tc:IsRelateToBattle() then
		if tc:GetFlagEffectLabel(76859105)==fid then
			Duel.Hint(HINT_CARD,0,76859105)
			local bc=tc:GetBattleTarget()
			if bc then
				local atk=bc:GetAttack()/2
				Duel.Recover(tp,atk,REASON_EFFECT)
				if Duel.Destroy(bc,REASON_EFFECT) then
					local g=Duel.GetMatchingGroup(c76859105.ofilter11,tp,LOCATION_DECK,0,nil)
					if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(76859105,0)) then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
						local tg=g:Select(tp,1,1,nil)
						Duel.SendtoHand(tg,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,tg)
					end
				end
			end
		end
	end
end