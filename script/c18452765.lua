--NightCore - Desperate
function c18452765.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetTarget(c18452765.tar1)
	e1:SetOperation(c18452765.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCountLimit(1,18452765)
	e3:SetTarget(c18452765.tar3)
	e3:SetOperation(c18452765.op3)
	c:RegisterEffect(e3)
end
function c18452765.tfil11(c,tp)
	return c:IsSetCard(0x2d5) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(c18452765.tfil12,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function c18452765.tfil12(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c18452765.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452765.tfil11,tp,LOCATION_DECK,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c18452765.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18452765.tfil11,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,c18452765.tfil12,tp,LOCATION_DECK,0,1,1,tc,tc:GetCode())
	Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
end
function c18452765.tfil3(c)
	return c:IsSetCard(0x2d5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c18452765.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and chkc~=c and c18452765.tfil3(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c18452765.tfil3,tp,LOCATION_GRAVE,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c18452765.tfil3,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c18452765.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end