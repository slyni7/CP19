--패스파인더 배리어 모듈
function c52643004.initial_effect(c)
    c:EnableCounterPermit(0x5ff)
	--1장밖에 존재할 수 없음
	c:SetUniqueOnField(1,0,52643004)
	--발동
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
	--카운터 3개 파괴내성
	local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    e2:SetRange(LOCATION_SZONE)
    e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetCondition(c52643004.indcon)
    e2:SetTarget(c52643004.indtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
	--카운터 3개 데미지 0
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_CHANGE_DAMAGE)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c52643004.indcon)
    e3:SetTargetRange(1,0)
    e3:SetValue(c52643004.damval)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
    c:RegisterEffect(e4)
	--릴리스 +1
	local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(52643004,1))
    e5:SetCategory(CATEGORY_COUNTER)
	e5:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
    e5:SetCost(c52643004.cost1)
    e5:SetTarget(c52643004.addct)
	e5:SetOperation(c52643004.op1)
    c:RegisterEffect(e5,false,1)
	--1500LP +1
	local e6=Effect.CreateEffect(c)
    e6:SetDescription(aux.Stringid(52643004,2))
	e6:SetCategory(CATEGORY_COUNTER)
    e6:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
    e6:SetCost(c52643004.cost2)
	e6:SetTarget(c52643004.addct)
    e6:SetOperation(c52643004.op1)
    c:RegisterEffect(e6,false,1)
	--+1 소환불가
	local e7=Effect.CreateEffect(c)
    e7:SetDescription(aux.Stringid(52643004,3))
	e7:SetCategory(CATEGORY_COUNTER)
    e7:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
    e7:SetType(EFFECT_TYPE_IGNITION)
    e7:SetRange(LOCATION_SZONE)
    e7:SetCountLimit(1)
	e7:SetTarget(c52643004.addct)
    e7:SetOperation(c52643004.op3)
    c:RegisterEffect(e7)
end
function c52643004.indcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetCounter(0x5ff)>=3
end
function c52643004.indtg(e,c)
    return c:IsSetCard(0x5f3) and c:GetSequence()<5
end
function c52643004.damval(e,re,val,r,rp,rc)
    if bit.band(r,REASON_EFFECT)~=0 then return 0 end
    return val
end
function c52643004.cfilter(c,ft,tp)
    return c:IsFaceup() and c:IsSetCard(0x5f3)
end
function c52643004.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c52643004.cfilter,1,nil,ft,tp) end
    local g=Duel.SelectReleaseGroup(tp,c52643004.cfilter,1,1,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end
function c52643004.addct(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,99,0,0x5ff)
end
function c52643004.op1(e,tp,eg,ep,ev,re,r,rp)
     if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5ff,1)
    end
end
function c52643004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1500) end
    Duel.PayLPCost(tp,1500)
end
function c52643004.op3(e,tp,eg,ep,ev,re,r,rp)
     if e:GetHandler():IsRelateToEffect(e) then
        e:GetHandler():AddCounter(0x5ff,1)
    end
	local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_CANNOT_SUMMON)
    e1:SetReset(RESET_PHASE+PHASE_END)
    e1:SetTargetRange(1,0)
    Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetReset(RESET_PHASE+PHASE_END)
    e2:SetTargetRange(1,0)
    Duel.RegisterEffect(e2,tp)
end