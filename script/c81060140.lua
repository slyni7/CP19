--이지~노멀 세이란 1스펠

function c81060140.initial_effect(c)

	--reduct
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c81060140.rdcn)
	e2:SetTarget(c81060140.rdtg)
	e2:SetOperation(c81060140.rdop)
	c:RegisterEffect(e2)
	
	--token
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81060140,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,81060140+EFFECT_COUNT_CODE_OATH)
	e3:SetCost(c81060140.tkco)
	e3:SetTarget(c81060140.tktg)
	e3:SetOperation(c81060140.tkop)
	c:RegisterEffect(e3)
	
end

--reduct
function c81060140.rdcnfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca7) and c:IsType(TYPE_MONSTER)
end
function c81060140.rdcn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81060140.rdcnfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c81060140.rdtgfilter(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c81060140.rdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c81060140.rdtgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c81060140.rdtgfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81060140.rdtgfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end

function c81060140.rdopfilter(c)
	return c:IsDestructable()
end
function c81060140.rdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and not c:IsDisabled() and tc:IsRelateToEffect(e) then
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
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c81060140.rdopfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if dg:GetCount()>0 then
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end

--token
function c81060140.tkco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function c81060140.tktgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca7) and c:IsReleasable()
	and not c:IsType(TYPE_TOKEN)
end
function c81060140.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp)
	and c81060140.tktgfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,81060141,0xca7,0x4011,1000,1000,2,RACE_BEAST,ATTRIBUTE_DARK) 
	and Duel.IsExistingTarget(c81060140.tktgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c81060140.tktgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end

function c81060140.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)~=0 and
		Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,81060141,0xca7,0x4011,1000,1000,2,RACE_BEAST,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,81060141)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			token:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(1)
			token:RegisterEffect(e2,true)
		end
		Duel.SpecialSummonComplete()
	end
end
