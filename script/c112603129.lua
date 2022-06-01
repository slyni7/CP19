--의미상의 이로카와 루키
local m=112603129
local cm=_G["c"..m]
function cm.initial_effect(c)
	--hand link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(cm.matval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(cm.indcon)
	e2:SetOperation(cm.indop)
	c:RegisterEffect(e2)
end

--hand link
function cm.exmfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsCode(m)
end
function cm.matval(e,lc,mg,c,tp)
	if not lc:IsCode(112603123) then return false,nil end
	return true,not mg or not mg:IsExists(cm.exmfilter,1,nil)
end

--indes
function cm.indcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_LINK
end
function cm.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(cm.indval)
	e1:SetOwnerPlayer(ep)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function cm.indval(e,re,rp)
	return rp==1-e:GetOwnerPlayer()
end