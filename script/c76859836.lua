--�ƴ������� Ÿ��
function c76859836.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCountLimit(1,76859836)
	e1:SetCondition(c76859836.con1)
	e1:SetTarget(c76859836.tar1)
	e1:SetOperation(c76859836.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetCountLimit(1,76859837)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c76859836.tar2)
	e2:SetOperation(c76859836.op2)
	c:RegisterEffect(e2)
end
function c76859836.nfil2(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsSetCard(0x2cb))
end
function c76859836.con1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c76859836.nfil2,tp,LOCATION_MZONE,0,1,nil)
end
function c76859836.tfil1(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and not c:IsSetCard(0x2cb)
end
function c76859836.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859836.tfil1,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c76859836.tfil1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c76859836.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c76859836.tfil1,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.GetControl(tc,tp,PHASE_END,1) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_SETCODE)
			e1:SetValue(0x2cb)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
end
function c76859836.tfil2(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c76859836.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859836.tfil2,tp,0,LOCATION_ONFIELD,1,nil)
	end
	local g=Duel.GetMatchingGroup(c76859836.tfil2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c76859836.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c76859836.tfil2,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
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