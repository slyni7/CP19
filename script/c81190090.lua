--1항전
function c81190090.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81190090+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81190090.tg1)
	e1:SetOperation(c81190090.op1)
	c:RegisterEffect(e1)
	
	--can't be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(811900090,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c81190090.cn2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81190090.tg2)
	e2:SetOperation(c81190090.op2)
	c:RegisterEffect(e2)
end

--act
function c81190090.filter1(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcb6) and c:IsType(TYPE_MONSTER)
end
function c81190090.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190090.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsPlayerCanSummon(tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81190090.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81190090.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(81190090,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(c81190090.vtg)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81190090.vtg(e,c)
	return c:IsSetCard(0xcb6) and c:IsType(TYPE_SPIRIT)
end

--
function c81190090.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c81190090.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xcb6) and c:GetFlagEffect(81190090)==0
end
function c81190090.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsOnField() and c81190090.filter2(chkc,e)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81190090.filter2,tp,LOCATION_MZONE,0,1,nil,e)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81190090.filter2,tp,LOCATION_MZONE,0,1,1,nil,e)
end
function c81190090.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and tc:GetFlagEffect(81190090)==0 then
		tc:RegisterFlagEffect(81190090,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(81190090,2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e1:SetValue(aux.tgoval)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_NEGATE)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c81190090.vcn2)
		e2:SetOperation(c81190090.vop2)
		e2:SetLabelObject(tc)
		e2:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c81190090.vcn2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(81190090)==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(tc)
end
function c81190090.vop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end


