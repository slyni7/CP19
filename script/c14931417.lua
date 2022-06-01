--빗방울 블루베리
function c14931417.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c14931417.lcheck)
	c:EnableReviveLimit()
	--protect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c14931417.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xfe,LOCATION_HAND+LOCATION_ONFIELD)
	e2:SetValue(LOCATION_DECKBOT)
	e2:SetCondition(c14931417.condition)
	e2:SetTarget(c14931417.rmtg)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCondition(c14931417.thcon)
	e3:SetTarget(c14931417.thtg)
	e3:SetOperation(c14931417.thop)
	c:RegisterEffect(e3)
end
function c14931417.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xb93)
end
function c14931417.tgtg(e,c)
	local oc=e:GetHandler()
	return c==oc or oc:GetLinkedGroup():IsContains(c)
end
function c14931417.condition(e)
	return e:GetHandler():GetSequence()>4
end
function c14931417.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c14931417.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT))
		and c:IsPreviousPosition(POS_FACEUP)
end
function c14931417.thfilter(c)
	return c:IsSetCard(0xb93) and c:IsAbleToHand()
end
function c14931417.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c14931417.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c14931417.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c14931417.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c14931417.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end