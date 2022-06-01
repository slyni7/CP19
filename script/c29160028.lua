--Çý¾ÈÀÇ EDM
function c29160028.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum set
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c29160028.pencon)
	e2:SetTarget(c29160028.pentg)
	e2:SetOperation(c29160028.penop)
	c:RegisterEffect(e2)
	--scale
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29160028,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c29160028.sccost)
	e3:SetTarget(c29160028.sctg)
	e3:SetOperation(c29160028.scop)
	c:RegisterEffect(e3)
end
function c29160028.cfilter(c)
	return c:IsSetCard(0x2c7)
end
function c29160028.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29160028.cfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c29160028.penfilter(c)
	return c:IsSetCard(0x2c7) and c:IsType(TYPE_PENDULUM) and not c:IsCode(29160028) and not c:IsForbidden()
end
function c29160028.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c29160028.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c29160028.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,c29160028.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			Duel.RaiseSingleEvent(tc,EVENT_DESTROY,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
			Duel.RaiseEvent(g,EVENT_DESTROY,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
			Duel.RaiseSingleEvent(tc,EVENT_DESTROYED,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
			Duel.RaiseEvent(g,EVENT_DESTROYED,e,REASON_EFFECT+REASON_DESTROY,tp,0,0)
		end
	end
end
function c29160028.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_DISCARD+REASON_COST)
end
function c29160028.scfilter(c)
	return c:GetLeftScale()~=c:GetOriginalLeftScale()
end
function c29160028.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and c29160028.scfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c29160028.scfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c29160028.scfilter,tp,LOCATION_PZONE,0,1,1,nil)
end
function c29160028.scop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(tc:GetOriginalLeftScale())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		e2:SetValue(tc:GetOriginalRightScale())
		tc:RegisterEffect(e2)
	end
end
