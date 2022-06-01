--시산지술
--카드군 번호: 0xcbe
function c81250090.initial_effect(c)

	c:SetUniqueOnField(1,0,81250090)
	
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c81250090.cn1)
	e1:SetTarget(c81250090.tg1)
	e1:SetOperation(c81250090.op1)
	c:RegisterEffect(e1)
	--자기파괴
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c81250090.cn2)
	e2:SetOperation(c81250090.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_LEAVE_FIELD_P)
	e3:SetOperation(c81250090.chkop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c81250090.dop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end

--컨트롤탈취
function c81250090.cfilter(c)
	return c:IsFaceup() and c:IsCode(81250070)
end
function c81250090.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81250090.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

function c81250090.filter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81250090.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c81250090.filter0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81250090.filter0,tp,0,LOCATION_GRAVE,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81250090.filter0,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81250090.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then	
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetCondition(c81250090.rcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetDescription(aux.Stringid(81250090,0))
		e3:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetCode(EFFECT_CHANGE_SETCODE)
		e3:SetValue(0xcbe)
		tc:RegisterEffect(e3)
		Duel.SpecialSummonComplete()
	end
end
function c81250090.rcon(e)
	return e:GetHandler():IsControler(e:GetOwner():GetControler())
end

--자기파괴
function c81250090.chkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c81250090.dop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then
		return
	end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c81250090.cn2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c81250090.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end


