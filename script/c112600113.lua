--3
function c112600113.initial_effect(c)
	c:SetSPSummonOnce(112600113)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(112600113,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c112600113.cost)
	e3:SetTarget(c112600113.target)
	e3:SetOperation(c112600113.operation)
	c:RegisterEffect(e3)
	--damage
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(112600113,0))
	ea:SetCategory(CATEGORY_DAMAGE)
	ea:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DELAY)
	ea:SetCode(EVENT_SUMMON_SUCCESS)
	ea:SetTarget(c112600113.damtg)
	ea:SetOperation(c112600113.damop)
	c:RegisterEffect(ea)
	local eb=ea:Clone()
	eb:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(eb)
end
function c112600113.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,300)
end
function c112600113.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c112600113.cfilter(c)
	return c:IsSetCard(0xe8c) and c:IsAbleToRemoveAsCost()
end
function c112600113.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600113.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c112600113.cfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c112600113.filter(c)
	return c:IsSetCard(0xe8c) and c:IsSummonable(true,nil)
end
function c112600113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112600113.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c112600113.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c112600113.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end