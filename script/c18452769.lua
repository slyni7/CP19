--NightCore - Hallow
function c18452769.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x2d5),1,1)
	c:SetSPSummonOnce(18452769)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c18452769.con1)
	e1:SetTarget(c18452769.tar1)
	e1:SetOperation(c18452769.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCountLimit(1,18452769)
	e2:SetTarget(c18452769.tar2)
	e2:SetOperation(c18452769.op2)
	c:RegisterEffect(e2)
end
function c18452769.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c18452769.tfil11(c,e,tp,zone)
	return c:IsSetCard(0x2d5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
		and Duel.IsExistingMatchingCard(c18452769.tfil12,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c18452769.tfil12(c,att)
	return c:IsSetCard(0x2d5) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and not c:IsAttribute(att)
end
function c18452769.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local zone=c:IsRelateToEffect(e) and c:GetLinkedZone(tp) or 0
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c18452769.tfil11(chkc,e,tp,0x1f-zone)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c18452769.tfil11,tp,LOCATION_GRAVE,0,1,nil,e,tp,0x1f-zone)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c18452769.tfil11,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,0x1f-zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c18452769.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:IsRelateToEffect(e) and c:GetLinkedZone(tp) or 0
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c18452769.tfil12,tp,LOCATION_DECK,0,1,1,nil,tc:GetAttribute())
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,0x1f-zone)
end
function c18452769.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c18452769.ofil21(c)
	return c:IsSetCard(0x2d5) and c:IsType(TYPE_MONSTER)
end
function c18452769.ofil22(c)
	return c:IsSetCard(0x2d5) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c18452769.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		if not Duel.IsExistingMatchingCard(c18452769.ofil21,tp,LOCATION_HAND,0,1,nil) then
			local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			Duel.SendtoGrave(hg,REASON_EFFECT)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,c18452769.ofil22,tp,LOCATION_HAND,0,1,1,nil)
			if #g>0 then
				Duel.ConfirmCards(1-tp,g)
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			else
				local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				Duel.ConfirmCards(1-tp,hg)
				Duel.ShuffleHand(tp)
			end
		end
	end
end