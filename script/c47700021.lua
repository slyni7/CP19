--미미크루 프렐류드
function c47700021.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,47700021+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c47700021.condition)
	e1:SetTarget(c47700021.target)
	e1:SetOperation(c47700021.op1)
	c:RegisterEffect(e1)
end

function c47700021.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x229)
end

function c47700021.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47700021.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,3,nil) and rp~=tp
	and Duel.IsChainNegatable(ev) and not re:GetHandler():IsSetCard(0x229)
end

function c47700021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function c47700021.op1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,POS_FACEUP,REASON_EFFECT)
	end
end