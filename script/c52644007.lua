--스타폴 샤프트
function c52644007.initial_effect(c)
	--엑시즈 소환
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5f4),11,3)
	c:EnableReviveLimit()
	--암석족이면 파괴 X
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c52644007.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c52644007.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(52644007,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,52644007)
	e3:SetCondition(c52644007.descon)
	e3:SetTarget(c52644007.destg)
	e3:SetOperation(c52644007.desop)
	c:RegisterEffect(e3)
	--종족 바꾸기
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(52644007,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c52644007.cost)
	e4:SetTarget(c52644007.chtg)
	e4:SetOperation(c52644007.chop)
	c:RegisterEffect(e4)
	
end
function c52644007.indcon(e)
	return e:GetHandler():IsRace(RACE_ROCK)
end
function c52644007.descon(e)
	return e:GetHandler():IsRace(RACE_PYRO)
end
function c52644007.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c52644007.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c52644007.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRace(RACE_ROCK) or e:GetHandler():IsRace(RACE_PYRO) end
end
function c52644007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetFlagEffect(tp,52644007)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,526440107,RESET_CHAIN,0,1)
end
function c52644007.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsRace(RACE_PYRO) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(RACE_ROCK)
		c:RegisterEffect(e1)
	elseif c:IsFaceup() and c:IsRelateToEffect(e) and c:IsRace(RACE_ROCK) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(RACE_PYRO)
		c:RegisterEffect(e2)
	end
end
