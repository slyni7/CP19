--FIREWORK!
local m=99970268
local cm=_G["c"..m]
function cm.initial_effect(c)

	--FIREWORK!
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.damtg)
	e1:SetOperation(cm.damop)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	
	--공수 증가
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.target)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
end

--FIREWORK!
function cm.damfilter(c)
	return ((c:IsSetCard(0xe03) and c:IsType(TYPE_TRAP)) or (c:IsSetCard(0xd3d) and c:IsType(TYPE_MONSTER)))
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.damfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=Duel.GetMatchingGroupCount(cm.damfilter,tp,LOCATION_GRAVE,0,nil)*500
	Duel.Damage(p,d,REASON_EFFECT)
end

--공수 증가
function cm.target(e,c)
	return (c:IsSetCard(0xe03) or c:IsCode(99970261)) and c:IsFaceup()
end
