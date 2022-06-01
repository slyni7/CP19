--오전 0시의 쓰리 스트라이크

function c81070090.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81070090.atcn)
	c:RegisterEffect(e0)
	
	--multiple attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,81070090)
	e2:SetCondition(c81070090.mpcn)
	e2:SetCost(c81070090.mpco)
	e2:SetTarget(c81070090.mptg)
	e2:SetOperation(c81070090.mpop)
	c:RegisterEffect(e2)
	
	--atk increase
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c81070090.aicn)
	e3:SetTarget(c81070090.aitg)
	e3:SetOperation(c81070090.aiop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c81070090.aicn2)
	c:RegisterEffect(e4)
	
end
--activate
function c81070090.atcnfilter(c)
	return c:IsFaceup() 
	   and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070090.atcn(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81070090.atcnfilter,tp,LOCATION_ONFIELD,0,nil)==0
end
--multiple attack
function c81070090.mpcnfilter(c)
	return c:IsFaceup() and c:IsCode(81070000)
end
function c81070090.mpcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81070090.mpcnfilter,tp,LOCATION_MZONE,0,1,nil)
	   and Duel.IsAbleToEnterBP()
end

function c81070090.mpcofilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcaa)
	   and c:IsAbleToGraveAsCost()
end
function c81070090.mpco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_DECK
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070090.mpcofilter,tp,loc,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81070090.mpcofilter,tp,loc,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function c81070090.mptgfilter(c)
	return c:IsFaceup() and c:IsType(0xcaa)
end
function c81070090.mptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return
				chkc:IsControler(tp)
			and chkc:IsLocation(LOCATION_MZONE)
			and c81070090.mptgfilter(chkc)
			end
	if chk==0 then return
				Duel.IsExistingTarget(c81070090.mptgfilter,tp,LOCATION_MZONE,0,1,nil)
			end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81070090.mptgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c81070090.attacker)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabel(g:GetFirst():GetFieldID())
	Duel.RegisterEffect(e1,tp)
end
function c81070090.attacker(e,c)
	return e:GetLabel()~=c:GetFieldID()
end

function c81070090.mpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

--atk increase
function c81070090.aicn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0)
	   and re:GetHandler():IsSetCard(0xcaa)
end
function c81070090.aicn2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end

function c81070090.aitgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcaa)
end
function c81070090.aitg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
				Duel.IsExistingMatchingCard(c81070090.aitgfilter,tp,LOCATION_MZONE,0,1,nil)
			end
end

function c81070090.aiop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c81070090.aitgfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
