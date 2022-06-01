--EDM 오비랍토르
function c29160016.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--to hand or grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29160016,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,29160016)
	e1:SetTarget(c29160016.target)
	e1:SetOperation(c29160016.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29160016,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,29160066)
	e3:SetTarget(c29160016.destg)
	e3:SetOperation(c29160016.desop)
	c:RegisterEffect(e3)
end
function c29160016.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x2c7)
end
function c29160016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c29160016.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c29160016.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(29160016,2))
	local g=Duel.SelectMatchingCard(tp,c29160016.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(29160016,2))) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT+REASON_DESTROY)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoExtraP(tc,tp,REASON_EFFECT+REASON_DESTROY)
		end
	end
end
function c29160016.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c7)
end
function c29160016.spfilter(c,e,tp)
	return c:IsSetCard(0x2c7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA))
		and ((c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp)>0)
			or (not c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function c29160016.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c29160016.desfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c29160016.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c29160016.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c29160016.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0
		and Duel.IsExistingMatchingCard(c29160016.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(29160016,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c29160016.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_PZONE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
end