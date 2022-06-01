function c81130050.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81130050.tg)
	e1:SetOperation(c81130050.op)
	c:RegisterEffect(e1)
end

--activate
function c81130050.mfilter(c)
	return c:IsSetCard(0xcb0) and c:IsAbleToHand() and not c:IsCode(81130050)
end
function c81130050.sfilter(c)
	return c:IsSetCard(0xcb0) and c:IsSummonable(true,nil)
end
function c81130050.ofilter1(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsFaceup()
end
function c81130050.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c81130050.ofilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81130050.mfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	local cat=CATEGORY_SEARCH+CATEGORY_TOHAND
	if ct>0 then cat=cat+CATEGORY_REMOVE+CATEGORY_SUMMON 
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
	end
	e:SetCategory(cat)
end
function c81130050.ofilter2(c)
	return c:IsSetCard(0xcb0) and c:IsAbleToRemove()
end
function c81130050.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81130050.mfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then 
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local ct1=Duel.GetMatchingGroupCount(c81130050.ofilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local ct2=Duel.GetMatchingGroupCount(c81130050.sfilter,tp,LOCATION_HAND,0,nil)
		local og1=Duel.GetMatchingGroup(c81130050.ofilter2,tp,LOCATION_GRAVE,0,nil)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ct1>0 and ct2>0 and og1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81130050,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local oc=og1:Select(tp,1,1,nil)
			Duel.Remove(oc,POS_FACEUP,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local og2=Duel.SelectMatchingCard(tp,c81130050.sfilter,tp,LOCATION_HAND,0,1,1,nil)
			Duel.Summon(tp,og2:GetFirst(),true,nil)
		end
	end
end


