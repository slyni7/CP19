--커앵우도위-기도섬
function c18452902.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c18452902.condition)
	e1:SetTarget(c18452902.target)
	e1:SetOperation(c18452902.activate)
	c:RegisterEffect(e1)
end
function c18452902.cfilter(c)
	return c:GetSequence()<5
end
function c18452902.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c18452902.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18452902.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function c18452902.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c18452902.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c18452902.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c18452902.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3 then
		e:SetCategory(CATEGORY_DISABLE+CATEGORY_CONTROL)
	else
		e:SetCategory(CATEGORY_DISABLE)
	end
end
function c18452902.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and not tc:IsDisabled() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3
			and tc:IsControler(1-tp) and tc:IsControlerCanBeChanged()
			and Duel.SelectYesNo(tp,aux.Stringid(18452902,0)) then
			Duel.BreakEffect()
			Duel.GetControl(tc,tp,PHASE_END,1)
		end
	end
end
