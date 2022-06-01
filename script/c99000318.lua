--³ì¿ÁÀÇ ¿¡½ºÆÛ ¸®Å°
local m=99000318
local cm=_G["c"..m]
function cm.initial_effect(c)
	--order summon
	aux.AddOrderProcedure(c,"L",nil,cm.ordfil1,cm.ordfil2)
	c:EnableReviveLimit()
	--reveal
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.rvcost)
	e1:SetOperation(cm.rvop)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.negcon)
	e2:SetCost(cm.negcost)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
end
cm.CardType_Order=true
function cm.ordfil1(c)
	return c:IsLevelAbove(5)
end
function cm.ordfil2(c)
	return c:IsLevelBelow(8)
end
function cm.cfilter(c)
	return c:IsType(TYPE_NORMAL) and not c:IsPublic()
end
function cm.rvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local sc=g:GetFirst()
	local e1=Effect.CreateEffect(sc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e1)
	e:SetLabelObject(sc)
	sc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
end
function cm.rvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=e:GetLabelObject()
	--remove
	local e1=Effect.CreateEffect(sc)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e1,true)
	--redirect
	local e2=Effect.CreateEffect(sc)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.redop)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e2,true)
	--Inactivate
	local e3=Effect.CreateEffect(sc)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(cm.discon)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.distg)
	e3:SetOperation(cm.disop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	sc:RegisterEffect(e3,true)
	if not sc:IsType(TYPE_EFFECT) then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ADD_TYPE)
		e4:SetValue(TYPE_EFFECT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e4,true)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()~=tp and chkc:GetLocation()==LOCATION_GRAVE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.redop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(0xfe,0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetTarget(cm.redtg)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function cm.redtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and Duel.IsChainDisablable(ev) and loc==LOCATION_GRAVE
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.cfilter2(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex2,g2,gc2,dp2,dv2=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	local ex3,g3,gc3,dp3,dv3=Duel.GetOperationInfo(ev,CATEGORY_TOEXTRA)
	local ex4,g4,gc4,dp4,dv4=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	local ex5,g5,gc5,dp5,dv5=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	local ex6=re:IsHasCategory(CATEGORY_GRAVE_ACTION)
	return ((ex1 and (bit.band(dv1,LOCATION_GRAVE)==LOCATION_GRAVE or g1 and g1:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))
		or (ex2 and (bit.band(dv2,LOCATION_GRAVE)==LOCATION_GRAVE or g2 and g2:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))
		or (ex3 and (bit.band(dv3,LOCATION_GRAVE)==LOCATION_GRAVE or g3 and g3:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))
		or (ex4 and (bit.band(dv4,LOCATION_GRAVE)==LOCATION_GRAVE or g4 and g4:IsExists(cm.cfilter2,1,nil)))
		or (ex5 and (bit.band(dv5,LOCATION_GRAVE)==LOCATION_GRAVE or g5 and g5:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE)))
		or ex6)
		and Duel.IsChainNegatable(ev)
end
function cm.costfilter(c)
	return not c:IsType(TYPE_EFFECT) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and c:IsAbleToGraveAsCost()
end
function cm.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
	end
end