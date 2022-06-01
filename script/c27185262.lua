--네크로의 다원마도서
function c27185262.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,27185262+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c27185262.cost2)
	e2:SetTarget(c27185262.tg2)
	e2:SetOperation(c27185262.op2)
	c:RegisterEffect(e2)
end
function c27185262.cfilter21(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0 and c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(c27185262.tfilter2,tp,LOCATION_GRAVE,0,1,c,e,tp)
end
function c27185262.cfilter22(c)
	return c:IsSetCard(0x306e) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function c27185262.tfilter2(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27185262.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c27185262.cfilter21,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(c27185262.cfilter22,tp,LOCATION_HAND,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,c27185262.cfilter21,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=rg:GetFirst()
	e:SetLabel(tc:GetLevel())
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c27185262.cfilter22,tp,LOCATION_HAND,0,1,1,c)
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
end
function c27185262.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27185262.tfilter2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c27185262.tfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c27185262.tfilter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,c,1,0,0)
end
function c27185262.val22(e,c)
	return c==e:GetLabelObject()
end
function c27185262.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		if e:GetLabel()>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_EQUIP)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(e:GetLabel())
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1)
		end
		Duel.Equip(tp,c,tc)
		Duel.SpecialSummonComplete()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EQUIP_LIMIT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetLabelObject(tc)
		e2:SetValue(c27185262.val22)
		c:RegisterEffect(e2)
	end
end