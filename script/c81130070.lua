function c81130070.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81130070.tg)
	e1:SetOperation(c81130070.op)
	c:RegisterEffect(e1)
end

--activate
function c81130070.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xcb0) and c:IsType(TYPE_MONSTER)
end
function c81130070.ofilter1(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsFaceup()
end
function c81130070.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(c81130070.ofilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81130070.filter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81130070.filter,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81130070.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local cat=CATEGORY_ATKCHANGE
	if ct>0 then cat=cat+CATEGORY_DISABLE
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
	e:SetCategory(cat)
end
function c81130070.ofilter2(c)
	return c:IsSetCard(0xcb0) and c:IsAbleToRemove()
end
function c81130070.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local ct=Duel.GetMatchingGroupCount(c81130070.ofilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local og1=Duel.GetMatchingGroup(c81130070.ofilter2,tp,LOCATION_GRAVE,0,1,nil)
		if ct>0 and og1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81130070,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local oc=og1:Select(tp,1,1,nil)
			Duel.Remove(oc,POS_FACEUP,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local dg=Duel.SelectMatchingCard(tp,c81130070.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
			local cg=dg:GetFirst()
			while cg do
				Duel.NegateRelatedChain(cg,RESET_TURN_SET)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE)
				e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				cg:RegisterEffect(e3)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_DISABLE_EFFECT)
				e4:SetValue(RESET_TURN_SET)
				e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				cg:RegisterEffect(e4)
				cg=dg:GetNext()
			end
		end
	end
end
function c81130070.dfilter(c)
	return c:IsFaceup() and not c:IsDisabled() and not c:IsType(TYPE_NORMAL)
end
