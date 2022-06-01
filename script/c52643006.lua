--패스파인더 테크 - 스텔스 모듈
function c52643006.initial_effect(c)
    c:EnableCounterPermit(0x5ff)
	--1장밖에 존재할 수 없음
	c:SetUniqueOnField(1,0,52643006)
	--발동
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--카운터 3개 대상 지정 내성
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c52643006.indcon)
    e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5f3))
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
	--파괴시 +1
	local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(52643006,1))
    e5:SetCategory(CATEGORY_COUNTER)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
    e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
    e5:SetCondition(c52643006.ctcon)
    e5:SetTarget(c52643006.addct)
	e5:SetOperation(c52643006.op1)
    c:RegisterEffect(e5,false,1)
	--1500LP +1
	local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(52643006,2))
	e6:SetCategory(CATEGORY_COUNTER)
    e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCost(c52643006.cost2)
    e6:SetTarget(c52643006.addct)
    e6:SetOperation(c52643006.op1)
    c:RegisterEffect(e6,false,1)
	--기계족 릴리스 +1
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(52643006,3))
	e7:SetCategory(CATEGORY_COUNTER)
    e7:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCountLimit(1)
	e7:SetCost(c52643006.cost1)
    e7:SetTarget(c52643006.addct)
	e7:SetOperation(c52643006.op1)
    c:RegisterEffect(e7)
end
function c52643006.indcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetCounter(0x5ff)>=3
end
function c52643006.addct(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,99,0,0x5ff)
end
function c52643006.op1(e,tp,eg,ep,ev,re,r,rp)
     if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5ff,1)
    end
end
function c52643006.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1500) end
    Duel.PayLPCost(tp,1500)
end
function c52643006.cfilter(c,ft,tp)
    return c:IsRace(RACE_MACHINE)
end
function c52643006.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c52643006.cfilter,1,nil,ft,tp) end
    local g=Duel.SelectReleaseGroup(tp,c52643006.cfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c52643006.cfilter1(c,tp)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp
end
function c52643006.ctcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c52643006.cfilter1,1,nil,tp)
end