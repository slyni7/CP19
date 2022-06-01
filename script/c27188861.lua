--토라의 다원마도서
function c27188861.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c27188861.tg2)
	e2:SetOperation(c27188861.op2)
	c:RegisterEffect(e2)
end
function c27188861.tfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function c27188861.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c27188861.tfilter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27188861.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECMTSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c27188861.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local opt=Duel.SelectOption(tp,aux.Stringid(27188861,0),aux.Stringid(27188861,1))
	e:SetLabel(opt)
end
function c27188861.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		if e:GetLabel()<1 then
			e1:SetValue(c27188861.val11)
		else
			e1:SetValue(c27188861.val12)
		end
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c27188861.val11(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwner()~=e:GetOwner()
end
function c27188861.val12(e,te)
	return te:IsActiveType(TYPE_TRAP)
end