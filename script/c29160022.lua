--EDM ºÓ≈© ∏∂Ω∫≈Õ
function c29160022.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29160022,3))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c29160022.pencon)
	e6:SetTarget(c29160022.pentg)
	e6:SetOperation(c29160022.penop)
	c:RegisterEffect(e6)
	--xyz summon
	aux.AddXyzProcedure(c,c29160022.matfilter,4,3)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29160022,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c29160022.cost)
	e1:SetTarget(c29160022.target)
	e1:SetOperation(c29160022.operation)
	c:RegisterEffect(e1,false,1)
end
c29160022.pendulum_level=4
function c29160022.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c29160022.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c29160022.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c29160022.matfilter(c)
	return c:IsSetCard(0x2c7)
end
function c29160022.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29160022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29160022,1))
	e:SetLabel(Duel.SelectOption(tp,70,71,72))
end
function c29160022.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	if e:GetLabel()==0 then
		e1:SetDescription(aux.Stringid(29160022,2))
		e1:SetValue(c29160022.aclimit1)
	elseif e:GetLabel()==1 then
		e1:SetDescription(aux.Stringid(29160022,3))
		e1:SetValue(c29160022.aclimit2)
	else
		e1:SetDescription(aux.Stringid(29160022,4))
		e1:SetValue(c29160022.aclimit3)
	end
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1,tp)
end
function c29160022.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c29160022.aclimit2(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL)
end
function c29160022.aclimit3(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP)
end
