--트솔라나이트 레미스
local m=18453291
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x2ec),4,2,cm.ovfilter,aux.Stringid(m,1),2,cm.xyzop)
	c:SetUniqueOnField(1,0,cm.ufil1,LOCATION_MZONE)
end
function cm.ufil1(c)
	return c:IsSetCard(0x2ec) and c:IsAttribute(ATTRIBUTE_WIND)
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2ec) and c:IsType(TYPE_XYZ)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END,0,1)
	return true
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.thfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsSetCard(0x2ec) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)))) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and cm.thfilter(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0
		and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	local b1=Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	local b2=Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
	else
		op=2
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=nil
	if op==0 then
		g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	elseif op==1 then
		g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	else
		g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
