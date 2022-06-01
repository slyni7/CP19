--7
function c112600117.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetDescription(aux.Stringid(112600117,0))
	e1:SetCountLimit(2,112600117)
	e1:SetCondition(c112600117.condition)
	e1:SetTarget(c112600117.damtg)
	e1:SetOperation(c112600117.damop)
	c:RegisterEffect(e1)
end
function c112600117.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c112600117.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c112600117.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe8c)
end
function c112600117.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c112600117.cfilter,tp,LOCATION_MZONE,0,1,nil)
end