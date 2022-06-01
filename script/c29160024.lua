--EDM 드란시아
function c29160024.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(29160024,3))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c29160024.pencon)
	e6:SetTarget(c29160024.pentg)
	e6:SetOperation(c29160024.penop)
	c:RegisterEffect(e6)
	--xyz summon
	aux.AddXyzProcedure(c,c29160024.matfilter,4,4,c29160024.ovfilter,aux.Stringid(29160024,0),4,c29160024.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c29160024.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c29160024.defval)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29160024,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetHintTiming(0,0x1e0)
	e3:SetCost(c29160024.descost)
	e3:SetTarget(c29160024.destg)
	e3:SetOperation(c29160024.desop)
	c:RegisterEffect(e3,false,1)
end
c29160024.pendulum_level=4
function c29160024.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c29160024.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c29160024.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c29160024.matfilter(c)
	return c:IsSetCard(0x2c7)
end
function c29160024.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c7) and not c:IsCode(29160024)
end
function c29160024.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,29160024)==0 end
	Duel.RegisterFlagEffect(tp,29160024,RESET_PHASE+PHASE_END,0,1)
	return true
end
function c29160024.atkfilter(c)
	return c:IsSetCard(0x2c7) and c:GetAttack()>=0
end
function c29160024.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c29160024.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c29160024.deffilter(c)
	return c:IsSetCard(0x2c7) and c:GetDefense()>=0
end
function c29160024.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c29160024.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c29160024.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c29160024.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29160024.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end