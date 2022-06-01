--경단 인플루엔스

function c81060150.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--continous
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xca7))
	e3:SetValue(-800)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	
	local e5=e3:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	
	local e6=e5:Clone(c)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(c81060150.cdvl)
	c:RegisterEffect(e6)
	
	--reduct
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(81060150,0))
	e7:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetHintTiming(0,0x1e0)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1,81060150)
	e7:SetTarget(c81060150.rdtg)
	e7:SetOperation(c81060150.rdop)
	c:RegisterEffect(e7)
	
	--return to deck
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_REMOVE)
	e8:SetRange(LOCATION_REMOVED)
	e8:SetCondition(c81060150.tdcn)
	e8:SetOperation(c81060150.tdop)
	c:RegisterEffect(e8)
	
end

--continous
function c81060150.cdvl(e,re,rp)
	return rp~=e:GetHandlerPlayer() and not re:GetHandler():IsImmuneToEffect(e)
end

--reduct
function c81060150.rdtgfilter1(c)
	return c:IsSetCard(0xca7) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c81060150.rdtgfilter2(c)
	return c:IsFaceup() and c:GetAttack()>0 and c:GetDefense()>0 
	and not c:IsDisabled() and c:IsType(TYPE_EFFECT)
end
function c81060150.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c81060150.rdtgfilter1,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingTarget(c81060150.rdtgfilter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectTarget(tp,c81060150.rdtgfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,c81060150.rdtgfilter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,g2,1,0,0)
end

function c81060150.rdop(e,tp,eg,ep,ev,re,r,rp)
	local ex1,dg=Duel.GetOperationInfo(0,CATEGORY_RELEASE)
	local ex2,cg=Duel.GetOperationInfo(0,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	local dc=dg:GetFirst()
	local cc=cg:GetFirst()
	if dc:IsRelateToEffect(e) and cc:IsRelateToEffect(e)
		and Duel.Release(dc,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if cc:IsFaceup() and cc:GetAttack()>0 and cc:GetDefense()>0 and not c:IsDisabled() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			cc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			cc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			cc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_DISABLE_EFFECT)
			e4:SetValue(RESET_TURN_SET)
			e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			cc:RegisterEffect(e4)
		end
	end
end

--return to deck
function c81060150.tdcn(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end

function c81060150.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
