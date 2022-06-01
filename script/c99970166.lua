--파이어워크 오르텐시아
local m=99970166
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd3d),2,2)
	c:EnableReviveLimit()
	
	--대상 내성 부여
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(cm.indcon)
	e1:SetTarget(cm.indtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	
	--데미지
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.damtg)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
	
end

--대상 내성 부여
function cm.indcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function cm.indtg(e,c)
	return e:GetHandler()==c or (c:IsSetCard(0xd3d) and e:GetHandler():GetLinkedGroup():IsContains(c))
end

--데미지
function cm.filter(c)
	return c:IsCode(46130346,73134081,19523799,46918794,33767325)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,ct*300,REASON_EFFECT)
end
