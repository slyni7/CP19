--5
function c112600115.initial_effect(c)
	--cost
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1)
	e6:SetCondition(c112600115.costcon)
	e6:SetOperation(c112600115.costop)
	c:RegisterEffect(e6)
	--END damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(112600115,1))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,112600115)
	e1:SetCondition(c112600115.condition)
	e1:SetTarget(c112600115.target)
	e1:SetOperation(c112600115.operation)
	c:RegisterEffect(e1)
	--damage
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(112600115,0))
	ea:SetCategory(CATEGORY_DAMAGE)
	ea:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	ea:SetCode(EVENT_SUMMON_SUCCESS)
	ea:SetTarget(c112600115.damtg)
	ea:SetOperation(c112600115.damop)
	c:RegisterEffect(ea)
	local eb=ea:Clone()
	eb:SetCode(EVENT_FLIP)
	c:RegisterEffect(eb)
end
function c112600115.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,600)
end
function c112600115.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c112600115.costcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c112600115.costop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(tp)>=700 then
		Duel.PayLPCost(tp,700)
	else
		Duel.SetLP(tp,0)
	end
end
function c112600115.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c112600115.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe8c)
end
function c112600115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c112600115.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c112600115.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(c112600115.filter,tp,LOCATION_MZONE,0,nil)
	Duel.Damage(p,ct*200,REASON_EFFECT)
end