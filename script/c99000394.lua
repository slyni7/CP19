--¹«³à ¹ÌÄÚ
local m=99000394
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(ea)
	--special summon rule
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_SPSUMMON_PROC)
	eb:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	eb:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	eb:SetRange(LOCATION_EXTRA)
	eb:SetCondition(cm.sprcon)
	eb:SetOperation(cm.sprop)
	c:RegisterEffect(eb)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--miko miko
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+10000)
	e2:SetCondition(cm.mikocon)
	e2:SetOperation(cm.mikoop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end
function cm.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function cm.sprfilter(c,tp,sc)
	return c:IsAbleToDeckAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)~=0 or Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)~=0)
		and Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_HAND,0,1,nil,tp,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.sprfilter,tp,LOCATION_HAND,0,1,1,nil,tp,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function cm.thfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAttack(500) and c:IsDefense(300) and c:IsType(TYPE_TUNER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local tg=sg:Select(1-tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.cfilter(c,p)
	return c:IsControler(p) and c:IsReason(REASON_EFFECT)
end
function cm.mikocon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,1-tp)
end
function cm.mikoop(e,tp,eg,ep,ev,re,r,rp)
	local opt=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1
	if opt==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetTargetRange(0xfe,0xff)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetTarget(cm.redtg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	elseif opt==2 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_REMOVE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if tp~=Duel.GetTurnPlayer() then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetValue(cm.aclimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.redtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_HAND
end