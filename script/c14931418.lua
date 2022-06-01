--Raindrop erica control
function c14931418.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14931418+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c14931418.target)
	e1:SetOperation(c14931418.activate)
	c:RegisterEffect(e1)
end
function c14931418.cfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xb93)
end
function c14931418.setfilter(c)
	return c:IsCode(14931419) and c:IsSSetable()
end
function c14931418.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c14931418.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(c14931418.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g1:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
	local b2=Duel.IsExistingMatchingCard(c14931418.setfilter,tp,LOCATION_DECK,0,1,nil) and g1:IsExists(Card.IsType,1,nil,TYPE_XYZ)
	local b3=Duel.IsExistingMatchingCard(c14931418.rmfilter,tp,LOCATION_GRAVE,0,1,nil) and g1:IsExists(Card.IsType,1,nil,TYPE_LINK)
	if chk==0 then return b1 or b2 or b3 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c14931418.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c14931418.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
	local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,14931401,0xb93,0x4011,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH) and g1:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
	local b2=Duel.IsExistingMatchingCard(c14931418.setfilter,tp,LOCATION_DECK,0,1,nil) and g1:IsExists(Card.IsType,1,nil,TYPE_XYZ)
	local b3=Duel.IsExistingMatchingCard(c14931418.rmfilter,tp,LOCATION_MZONE,0,1,nil) and g1:IsExists(Card.IsType,1,nil,TYPE_LINK)
	local res=0
	if b1 then
	for i=1,1 do
			local res=Duel.CreateToken(tp,14931401+i)
			Duel.SpecialSummonStep(res,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			res:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
	if b2 then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,c14931418.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc and Duel.SSet(tp,tc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		tc:RegisterEffect(e2)
		res=res+1
		end
	end
	if b3 then
		if res~=0 then Duel.BreakEffect() end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c14931418.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end