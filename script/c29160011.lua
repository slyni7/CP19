--EDM ºÒÈ¥
function c29160011.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29160011,3))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c29160011.pencon)
	e6:SetTarget(c29160011.pentg)
	e6:SetOperation(c29160011.penop)
	c:RegisterEffect(e6)
	--xyz summon
	aux.AddXyzProcedure(c,c29160011.matfilter,4,2,c29160011.ovfilter,aux.Stringid(29160011,0),2,c29160011.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c29160011.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c29160011.defval)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29160011,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c29160011.cost)
	e3:SetTarget(c29160011.target)
	e3:SetOperation(c29160011.operation)
	c:RegisterEffect(e3,false,1)
end
c29160011.pendulum_level=4
function c29160011.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c29160011.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c29160011.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c29160011.matfilter(c)
	return c:IsSetCard(0x2c7)
end
function c29160011.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c7) and not c:IsCode(29160011)
end
function c29160011.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29160011)==0 end
	Duel.RegisterFlagEffect(tp,29160011,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c29160011.atkfilter(c)
	return c:IsSetCard(0x2c7) and c:GetAttack()>=0
end
function c29160011.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c29160011.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c29160011.deffilter(c)
	return c:IsSetCard(0x2c7) and c:GetDefense()>=0
end
function c29160011.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c29160011.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c29160011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29160011.filter(c)
	return c:IsSetCard(0x2c7) and c:IsSummonableCard() and c:IsAbleToHand()
end
function c29160011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29160011.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29160011.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c29160011.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT+REASON_DESTROY)
		Duel.ConfirmCards(1-tp,g)
	end
end