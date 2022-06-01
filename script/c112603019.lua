--Re(리)：버스
local m=112603019
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableCounterPermit(0xe9c)
	--counter1
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CHAIN_SOLVING)
	e0:SetRange(LOCATION_SZONE)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetCondition(cm.ctcon)
	e0:SetOperation(cm.ctop)
	c:RegisterEffect(e0)
	--counter2
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ea:SetCode(EVENT_TO_GRAVE)
	ea:SetRange(LOCATION_SZONE)
	ea:SetOperation(cm.counter)
	c:RegisterEffect(ea)
	--Remove counter replace
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,0))
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_RCOUNTER_REPLACE+0xe9c)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(cm.rcon)
	e7:SetOperation(cm.rop)
	c:RegisterEffect(e7)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.pccon)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCost(cm.drcost1)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTarget(cm.desreptg)
	e5:SetOperation(cm.desrepop)
	c:RegisterEffect(e5)
end

--counter1
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xe9b) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xe9c,1)
end

--counter2
function cm.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK)
end
function cm.counter(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.cfilter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0xe9c,ct,true)
	end
end

--Remove counter replace
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActivated() and bit.band(r,REASON_COST)~=0 and ep==e:GetOwnerPlayer() and e:GetHandler():GetCounter(0xe9c)>=ev
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xe9c,ev,REASON_EFFECT)
end

--SpecialSummon
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0xe9b) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0xe9c,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetHandler():AddCounter(0xe9c,2)~=0 then
	end
end

--draw
function cm.drcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0xe9c,6,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0xe9c,6,REASON_COST)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--Destroy replace
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0xe9c)>0 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0xe9c,1,REASON_EFFECT)
end