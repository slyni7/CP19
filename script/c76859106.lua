--Angel Notes - 레인보우
function c76859106.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,76859106+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c76859106.con1)
	e1:SetTarget(c76859106.tg1)
	e1:SetOperation(c76859106.op1)
	c:RegisterEffect(e1)
end
function c76859106.nfilter1(c)
	return c:IsSetCard(0x2c8) and c:IsFaceup() and not c:IsCode(76859106)
end
function c76859106.con1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c76859106.nfilter1,tp,LOCATION_ONFIELD,0,1,nil) then
		return false
	end
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c76859106.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c76859106.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local rc=re:GetHandler()
	local atk=rc:GetAttack()/2
	if rc:IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	if atk>0 then
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end