--아르마의 다원마도서
function c27186159.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCountLimit(1,27186159+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c27186159.tg2)
	e2:SetOperation(c27186159.op2)
	c:RegisterEffect(e2)
end
function c27186159.tfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and c:GetCode()~=27186159 and c:IsAbleToHand()
end
function c27186159.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c27186159.tfilter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c27186159.tfilter2,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27186159.tfilter2,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27186159.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end