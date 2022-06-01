--몽실몽실 뷔페
local m=112401227
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--activity check
	Duel.AddCustomActivityCounter(1,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0xfe1))
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(1,tp,ACTIVITY_CHAIN)>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,Duel.GetCustomActivityCount(1,tp,ACTIVITY_CHAIN)) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(Duel.GetCustomActivityCount(1,tp,ACTIVITY_CHAIN))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if d>=10 then
	Duel.Draw(p,10,REASON_EFFECT)
	end
	if d<10 then
	Duel.Draw(p,d,REASON_EFFECT)
	end
end