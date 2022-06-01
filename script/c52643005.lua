--패스파인더 배리어 모듈
function c52643005.initial_effect(c)
    c:EnableCounterPermit(0x5ff)
	--1장밖에 존재할 수 없음
	c:SetUniqueOnField(1,0,52643005)
	--발동
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--카운터 3개 +1500/+1500
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c52643005.upcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5f3))
    e2:SetValue(1500)
    c:RegisterEffect(e2)
	local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
	--파괴 +1
	local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(52643005,1))
    e5:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(c52643005.destg)
    e5:SetOperation(c52643005.desop)
	e5:SetCountLimit(1)
    c:RegisterEffect(e5,false,1)
	--1500LP +1
	local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(52643005,2))
	e6:SetCategory(CATEGORY_COUNTER)
    e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
    e6:SetCost(c52643005.cost2)
	e6:SetTarget(c52643005.addct)
    e6:SetOperation(c52643005.op1)
    c:RegisterEffect(e6,false,1)
	--2000이상 릴리스
	local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(52643005,3))
	e7:SetCategory(CATEGORY_COUNTER)
    e7:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCountLimit(1)
	e7:SetCost(c52643005.cost1)
    e7:SetTarget(c52643005.addct)
	e7:SetOperation(c52643005.op1)
    c:RegisterEffect(e7)
end
function c52643005.filter1(c)
    return c:IsType(TYPE_MONSTER)
end
function c52643005.filter2(c)
    return c:IsSetCard(0x81) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c52643005.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c52643005.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
    end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,99,0,0x5ff)
end
function c52643005.desop(e,tp,eg,ep,ev,re,r,rp)
    if not e:GetHandler():IsRelateToEffect(e) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,c52643005.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
    if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
        if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5ff,1)
		end
    end
end
function c52643005.upcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetCounter(0x5ff)>=3
end
function c52643005.addct(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,99,0,0x5ff)
end
function c52643005.op1(e,tp,eg,ep,ev,re,r,rp)
     if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5ff,1)
    end
end
function c52643005.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1500) end
    Duel.PayLPCost(tp,1500)
end
function c52643005.cfilter(c,ft,tp)
    return c:IsAttackAbove(2000)
end
function c52643005.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c52643005.cfilter,1,nil,ft,tp) end
    local g=Duel.SelectReleaseGroup(tp,c52643005.cfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end