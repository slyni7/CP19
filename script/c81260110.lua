--펑크랙 기어 로더
--카드군 번호: 0xcbf
function c81260110.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(c81260110.mfilter),4,2)
	
	--위치 변경
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81260110,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1)
	e1:SetCost(c81260110.co1)
	e1:SetTarget(c81260110.tg1)
	e1:SetOperation(c81260110.op1)
	c:RegisterEffect(e1)
	
	--효과 무효
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81260110,3))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81260110.cn2)
	e2:SetTarget(c81260110.tg2)
	e2:SetOperation(c81260110.op2)
	c:RegisterEffect(e2)
end

--엑시즈 소환
function c81260110.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end

--위치 변경
function c81260110.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c81260110.filter0(c)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
end
function c81260110.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81260110.filter0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81260110.filter0,tp,0x02+0x0c,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81260110,0))
	Duel.SelectTarget(tp,c81260110.filter0,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x02+0x0c)
end
function c81260110.filter1(c)
	return c:IsSetCard(0xcbf) and ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() )
end
function c81260110.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) 
		or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
	local nseq=math.log(s,2)
	if Duel.MoveSequence(tc,nseq)~=0 then
		local g1=Duel.GetMatchingGroup(c81260110.filter1,tp,0x02+0x0c,0,nil)
		if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81260110,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=g1:Select(tp,1,1,nil)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end

--효과 무효
function c81260110.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
	and c:IsPreviousSetCard(0xcbf)
	and c:IsReason(REASON_BATTLE+REASON_EFFECT)
	and c:IsControler(tp)
end
function c81260110.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81260110.cfilter,1,nil,tp)
end
function c81260110.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField() and aux.disfilter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c81260110.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if ( ( tc:IsFaceup() and not tc:IsDisabled() ) or tc:IsType(TYPE_TRAPMONSTER) ) and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		elseif tc:IsType(TYPE_MONSTER) then
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_ATTACK_FINAL)
			e4:SetValue(0)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e5)
		end
	end
end


