--EDM 정예의 제피로스
function c29160026.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29160026,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE)
	e1:SetCountLimit(1,29160026+EFFECT_COUNT_CODE_DUEL)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c29160026.target)
	e1:SetOperation(c29160026.operation)
	c:RegisterEffect(e1)
end
function c29160026.costfilter(c,sc)
	if sc:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCountFromEx(tp,tp,c,sc)<1 then
			return false
		end
	end
	return c:IsFaceup() and c:IsAbleToHand()
end
function c29160026.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ft=0
	if c:IsLocation(LOCATION_EXTRA) then
		ft=Duel.GetLocationCountFromEx(tp)
	else
		ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	end
	if chk==0 then
		if ft<0 or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			return false
		end
		if ft==0 then
			return Duel.IsExistingTarget(c29160026.costfilter,tp,LOCATION_MZONE,0,1,c,c)
		else
			return Duel.IsExistingTarget(c29160026.costfilter,tp,LOCATION_ONFIELD,0,1,c,c)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Group.CreateGroup()
	if ft==0 then
		g=Duel.SelectTarget(tp,c29160026.costfilter,tp,LOCATION_MZONE,0,1,1,c,c)
	else
		g=Duel.SelectTarget(tp,c29160026.costfilter,tp,LOCATION_ONFIELD,0,1,1,c,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,400)
end
function c29160026.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT+REASON_DESTROY)>0
		and c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Recover(tp,400,REASON_EFFECT)
	end
end
