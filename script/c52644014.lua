--스타폴 헤테로스피어
function c52644014.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c52644014.synfilter),2)
    c:EnableReviveLimit()
	--공버프
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_UPDATE_ATTACK)
    e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e0:SetRange(LOCATION_MZONE)
    e0:SetValue(c52644014.atkval)
	c:RegisterEffect(e0)
	--암석족이면 파괴 X
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c52644014.indcon)
    e1:SetValue(1)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c52644014.indcon)
	e2:SetValue(1)
    c:RegisterEffect(e2)
	--화염족 내성
	local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(52644014,0))
    e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetCountLimit(1,52644014)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c52644014.negcost)
    e3:SetCondition(c52644014.negcon)
    e3:SetTarget(c52644014.negtg)
    e3:SetOperation(c52644014.negop)
    c:RegisterEffect(e3)
	--종족바꾸기
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(52644014,1))
    e4:SetCategory(CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCost(c52644014.cost)
	e4:SetTarget(c52644014.chtg)
	e4:SetOperation(c52644014.chop)
	c:RegisterEffect(e4)
	--스탠바이 암석
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(52644009,2))
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetTarget(c52644014.swtg)
	e4:SetOperation(c52644014.swop)
    c:RegisterEffect(e4)
end
function c52644014.ncostfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f4) 
end
function c52644014.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52644014.ncostfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c52644014.ncostfilter,tp,LOCATION_REMOVED,0,1,99,nil)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetLabel(g:GetSum(Card.GetLevel,nil))
end
function c52644014.negcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if ep==tp or c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
    return c:IsRace(RACE_PYRO) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c52644014.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		
    end
end
function c52644014.negop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
    if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        Duel.Destroy(eg,REASON_EFFECT)
		if ct >= 50 and g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
    end
end
function c52644014.synfilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c52644014.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
function c52644014.atkval(e,c)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,0,nil)
    return g:GetSum(Card.GetLevel)*100
end
function c52644014.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsRace(RACE_PYRO)
end
function c52644014.indcon(e)
    return e:GetHandler():IsRace(RACE_ROCK)
end
function c52644014.costfilter(c)
    return c:IsSetCard(0x5f4) and c:IsAbleToRemoveAsCost()
end

function c52644014.swtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return not e:GetHandler():IsRace(RACE_ROCK) end
end
function c52644014.swop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(RACE_ROCK)
        c:RegisterEffect(e1)
    end
end
function c52644014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52644014.costfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler()) and Duel.GetFlagEffect(tp,52644014)==0 end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c52644014.costfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,52644014,RESET_CHAIN,0,1)
end
function c52644014.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsRace(RACE_ROCK) or e:GetHandler():IsRace(RACE_PYRO) end
end
function c52644014.chop(e,tp,eg,ep,ev,re,r,rp)
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
