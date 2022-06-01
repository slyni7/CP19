--캡처 웹

function c81050100.initial_effect(c)

	--pos. change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81050100+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81050100.flcn)
	e1:SetTarget(c81050100.fltg)
	e1:SetOperation(c81050100.flop)
	c:RegisterEffect(e1)
	
	--pos. change(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81050100,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c81050100.glco)
	e2:SetTarget(c81050100.gltg)
	e2:SetOperation(c81050100.glop)
	c:RegisterEffect(e2)
	
end

--pos. change
function c81050100.flcnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca6)
end
function c81050100.flcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81050100.flcnfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end

function c81050100.fltgfilter(c)
	return c:IsFaceup() and not c:IsDisabled() 
end
function c81050100.fltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField() and c81050100.fltgfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81050100.fltgfilter,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81050100.fltgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c81050100.flop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(100)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e4)
	end
end

--pos. change(e2)
function c81050100.glco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end

function c81050100.tfil0(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c81050100.gltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c81050100.tfil0(chkc) end
	if chk==0 then return
				Duel.IsExistingTarget(c81050100.tfil0,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	local g=Duel.SelectTarget(tp,c81050100.tfil0,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end

function c81050100.glop(e,tp,eg,ep,ev,re,r,rp)
	if not tc:IsRelateToEffect(e) or tc:IsFaceup() then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsSetCard(0xca6) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	else
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,true)
	end
end
