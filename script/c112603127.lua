--후다 유미네
local m=112603127
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	
	--delight summon
	aux.AddDelightProcedure(c,cm.delfilter,1,1)
	c:EnableReviveLimit()
	
	--pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(cm.pencost)
	e2:SetTarget(cm.pentg)
	e2:SetOperation(cm.penop)
	c:RegisterEffect(e2)
	
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m+1)
	e1:SetCondition(cm.succon)
	e1:SetTarget(cm.suctg)
	e1:SetOperation(cm.sucop)
	c:RegisterEffect(e1)
	
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(cm.tgtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	
	--tohand
	local e10=Effect.CreateEffect(c)
	e10:SetCategory(CATEGORY_TOHAND)
	e10:SetDescription(aux.Stringid(m,2))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetCountLimit(1)
	e10:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTarget(cm.target)
	e10:SetOperation(cm.operation)
	c:RegisterEffect(e10)
	
	--pendulum set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m)
	e6:SetTarget(cm.rettg)
	e6:SetOperation(cm.retop)
	c:RegisterEffect(e6)
	
end

cm.custom_type=CUSTOMTYPE_DELIGHT

--delight summon
function cm.delfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsCode(m)
end

--pendulum
function cm.pencostfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.pencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.pencostfilter,1,nil,tp) end
	local g=Duel.SelectReleaseGroup(tp,cm.pencostfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function cm.penfilter(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and not c:IsForbidden() and not c:IsCode(m)
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil)
	end
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end

--summon success
function cm.succon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_DELIGHT)
end
function cm.sucfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and not c:IsForbidden()
end
function cm.suctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(cm.sucfilter,tp,LOCATION_EXTRA,0,1,nil)
	end
end
function cm.sucop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.sucfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

--cannot be target 
function cm.tgtg(e,c)
	return c:IsType(TYPE_PENDULUM) and c~=e:GetHandler()
end

--to hand
function cm.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

--pendulum set
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then
      return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
   end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if not c:IsRelateToEffect(e) then
      return
   end
   if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
      Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
   end
end