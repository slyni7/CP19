--콜라보레이터 스베니어 마니바스
local m=52648015
local cm=_G["c"..m]
function c52648015.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5f8),4,2)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DESTROY_REPLACE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(cm.desreptg)
    e1:SetValue(cm.desrepval)
    e1:SetOperation(cm.desrepop)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
   e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
   e3:SetType(EFFECT_TYPE_IGNITION)
   e3:SetRange(LOCATION_PZONE)
   e3:SetCountLimit(1,152648015)
   e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
   e3:SetTarget(cm.sptarget)
   e3:SetOperation(cm.spop)
   c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(cm.pencon)
	e6:SetTarget(cm.pentg)
	e6:SetOperation(cm.penop)
	c:RegisterEffect(e6)
end
cm.pendulum_level=4
function cm.filter(c)
   return c:IsFaceup() and c:GetCounter(0x1019)>1
end
function cm.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
   if chkc then return chkc:IsOnField() and cm.filter(chkc) end
   if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
   local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) or c:IsImmuneToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc then
		Duel.SpecialSummon(c,nil,tp,tp,false,false,POS_FACEUP)
		Duel.Overlay(c,tc)
	end
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

function cm.sumfilter2(c)
	return c:IsAbleToHand() and c:GetCounter(0x1019)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
		and e:GetHandler():GetAttackAnnouncedCount()==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local dg=Duel.SelectMatchingCard(tp,cm.sumfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local ct2=Duel.SendtoHand(dg,nil,REASON_EFFECT)
end
function cm.repfilter(c,tp)
    return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
        and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
        and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
    return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
    return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
    Duel.Hint(HINT_CARD,1-tp,m)
end