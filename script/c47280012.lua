--엔트로피=맥스웰
local m=47280012
local cm=_G["c"..m]

function cm.initial_effect(c)

	--module summon
	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,cm.pfil1,aux.FilterBoolFunction(Card.IsSetCard,0xe25),2,10,nil)

	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)

	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)

	--Todeck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(cm.tdtg)
	e3:SetOperation(cm.tdop)
	c:RegisterEffect(e3)
	
end

function cm.pfil1(c)
	return c:IsType(TYPE_MODULE) and not c:IsCode(m)
end


function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and Duel.IsChainNegatable(ev) and e:GetHandler():GetEquipCount()>0
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end


function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end

function cm.rmop(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()
	local ct=0

	if c:IsAttribute(ATTRIBUTE_DARK) then ct=ct+1 end
	if c:IsAttribute(ATTRIBUTE_DIVINE) then ct=ct+1 end
	if c:IsAttribute(ATTRIBUTE_EARTH) then ct=ct+1 end
	if c:IsAttribute(ATTRIBUTE_FIRE) then ct=ct+1 end
	if c:IsAttribute(ATTRIBUTE_LIGHT) then ct=ct+1 end
	if c:IsAttribute(ATTRIBUTE_WATER) then ct=ct+1 end
	if c:IsAttribute(ATTRIBUTE_WIND) then ct=ct+1 end

	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if ct>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		if Duel.Remove(dg,POS_FACEUP,REASON_EFFECT) and ct>=6 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			local og=Duel.GetOperatedGroup()
			local ct2=og:FilterCount(Card.IsLocation,nil,nil,LOCATION_REMOVED)
			Duel.Damage(1-tp,300*ct2,REASON_EFFECT)
		end
	end
end


function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end