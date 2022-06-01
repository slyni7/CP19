--정신 지배
function c47800025.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCountLimit(1,47800025)
	e1:SetCost(c47800025.sgcost)
	e1:SetCondition(c47800025.con1)
	e1:SetTarget(c47800025.tar1)
	e1:SetOperation(c47800025.op1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(47800025,ACTIVITY_CHAIN,aux.FALSE)
end
function c47800025.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(47800025,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c47800025.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800025.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47800025.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c47800025.tfil1(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c47800025.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c47800025.tfil1,tp,0,LOCATION_MZONE,1,nil)
	end
	local g=Duel.GetMatchingGroup(c47800025.tfil1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c47800025.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c47800025.tfil1,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.GetControl(tc,tp)
	end
end