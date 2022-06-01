--스크립트_디스에이블
function c27182815.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetCondition(c27182815.con1)
	e1:SetTarget(c27182815.tg1)
	e1:SetOperation(c27182815.op1)
	c:RegisterEffect(e1)
end
function c27182815.nfilter1(c)
	return c:IsSetCard(0x2c2) and c:IsFaceup()
end
function c27182815.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27182815.nfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)>5
end
function c27182815.tfilter1(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c27182815.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField()
			and c27182815.tfilter1(chkc)
			and chkc~=c
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27182815.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local g=Duel.SelectTarget(tp,c27182815.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	else
		local g=Duel.SelectTarget(tp,c27182815.tfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c27182815.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end