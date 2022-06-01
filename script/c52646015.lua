--소울메이트 「인연」
function c52646015.initial_effect(c)
    --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5f6),5,5)
    c:EnableReviveLimit()
	--엑소재 흡수우우
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(52646015,1))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c52646015.mttg)
	e1:SetOperation(c52646015.mtop)
	c:RegisterEffect(e1)
	-- 6+ 더블어택
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(52646015,0))
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
    e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c52646015.ovlinkcon6)
    e2:SetCode(EFFECT_EXTRA_ATTACK)
    e2:SetValue(1)
    c:RegisterEffect(e2)
	-- 10+ 전투내성
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c52646015.ovlinkcon10)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)
	-- 8+ 전투시 파괴안되면 제외빵
	local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(52646015,1))
    e4:SetCategory(CATEGORY_REMOVE)
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_DAMAGE_STEP_END)
    e4:SetCondition(c52646015.rmcon)
    e4:SetTarget(c52646015.rmtg)
    e4:SetOperation(c52646015.rmop)
    c:RegisterEffect(e4)
	-- 10+ 죠노우치 파이어
	local e5=Effect.CreateEffect(c)
    e5:SetDescription(aux.Stringid(52646015,2))
    e5:SetCategory(CATEGORY_DAMAGE)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1,52646015)
	e5:SetCondition(c52646015.ovlinkcon10)
    e5:SetTarget(c52646015.target)
    e5:SetOperation(c52646015.operation)
    c:RegisterEffect(e5)
	-- 상대한테 완☆전☆내☆성
	local e6=Effect.CreateEffect(c)
    e6:SetType(EFFECT_TYPE_SINGLE)
    e6:SetCode(EFFECT_IMMUNE_EFFECT)
    e6:SetRange(LOCATION_MZONE)
    e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e6:SetValue(c52646015.val11)
    c:RegisterEffect(e6)
	--상대 엔드에 하나 제거!
	local e7=Effect.CreateEffect(c)
    e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e7:SetCode(EVENT_PHASE+PHASE_END)
    e7:SetRange(LOCATION_MZONE)
    e7:SetCountLimit(1)
    e7:SetCondition(c52646015.endrmcon)
    e7:SetOperation(c52646015.endrmop)
    c:RegisterEffect(e7)
end
function c52646015.endrmcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()~=tp
end
function c52646015.endrmop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:GetOverlayCount()>0 then
        c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
    end
end
function c52646015.val11(e,te)
    return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c52646015.linkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c52646015.ovlinkcon6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646015.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=6
end
function c52646015.ovlinkcon10(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646015.linkfilter,nil)
    return g:GetSum(Card.GetLink,nil)>=10
end
function c52646015.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
	local c=e:GetHandler()
    local g=c:GetOverlayGroup():Filter(c52646015.linkfilter,nil)
    local dm=g:GetSum(Card.GetLink,nil)*400
	Duel.SetTargetPlayer(1-tp)
    Duel.SetTargetParam(dm)
    Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dm)
end
function c52646015.operation(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Damage(p,d,REASON_EFFECT)
end
function c52646015.rmcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(c52646015.linkfilter,nil)
    if g:GetSum(Card.GetLink,nil)>=8 then
    local bc=c:GetBattleTarget()
    e:SetLabelObject(bc)
    return c==Duel.GetAttacker() and bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() and bc:IsRelateToBattle()
	end
end
function c52646015.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetLabelObject():IsAbleToRemove() end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetLabelObject(),1,0,0)
end
function c52646015.rmop(e,tp,eg,ep,ev,re,r,rp)
    local bc=e:GetLabelObject()
    if bc:IsRelateToBattle() then
        Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
    end
end
function c52646015.spcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c52646015.mtfilter(c,e)
   return not c:IsImmuneToEffect(e) and c:IsSetCard(0x5f7)
end
function c52646015.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.IsExistingMatchingCard(c52646015.mtfilter,tp,LOCATION_GRAVE,0,1,nil,e) end
end
function c52646015.mtop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if not c:IsRelateToEffect(e) then return end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
   local g=Duel.SelectMatchingCard(tp,c52646015.mtfilter,tp,LOCATION_GRAVE,0,1,63,nil,e)
   if g:GetCount()>0 then
      Duel.Overlay(c,g)
   end
end