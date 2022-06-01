--스크립트_인디스트럭터블
function c27182820.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c27182820.tg1)
	e1:SetOperation(c27182820.op1)
	c:RegisterEffect(e1)
end
function c27182820.tfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x2c2)
end
function c27182820.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField()
			and chkc:IsControler(tp)
			and c27182820.tfilter1(chkc)
			and chkc~=c
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182820.tfilter1,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local g=Duel.SelectTarget(tp,c27182820.tfilter1,tp,LOCATION_ONFIELD,0,1,1,c)
	else
		local g=Duel.SelectTarget(tp,c27182820.tfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	end
end
function c27182820.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end