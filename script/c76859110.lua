--Angel Notes - ¸á·Îµð
function c76859110.initial_effect(c)
	local e1=aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x2c8),nil,nil,nil,c76859110.op1)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_OATH+76859110)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_SWAP_BASE_AD)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e4:SetCountLimit(1)
	e4:SetCondition(c76859110.con4)
	e4:SetTarget(c76859110.tg4)
	e4:SetOperation(c76859110.op4)
	c:RegisterEffect(e4)
end
function c76859110.ofilter1(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_SPELL) and c:IsAbleToHand() and not c:IsCode(76859110)
end
function c76859110.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c76859110.ofilter1,tp,LOCATION_DECK,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(76859110,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c76859110.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c76859110.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c76859110.ofilter41(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function c76859110.ofilter42(c)
	return c:IsSetCard(0x2c8) and c:IsType(TYPE_TRAP)
end
function c76859110.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c76859110.ofilter41,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	else
		if Duel.IsExistingMatchingCard(c76859110.ofilter42,tp,LOCATION_DECK,0,1,nil) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if dg:GetCount()>0 then
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end