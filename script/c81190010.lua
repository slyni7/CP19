--IJN 후부키
function c81190010.initial_effect(c)

	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81190010.lm1)
	c:RegisterEffect(e1)
	
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81190010,0))
	e2:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c81190010.tg2)
	e2:SetOperation(c81190010.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	
	--dump
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81190010,2))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,81190010)
	e4:SetTarget(c81190010.tg4)
	e4:SetOperation(c81190010.op4)
	c:RegisterEffect(e4)
end

--splimit
function c81190010.lm1(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xcb6)
end

--token
function c81190010.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81190010.filter1(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsSetCard(0xcb6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81190010.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then
		return
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,81190011,0xcb6,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_FIRE) then
		local gc=Duel.CreateToken(tp,81190011)
		local g=Duel.GetMatchingGroup(c81190010.filter1,tp,LOCATION_HAND,0,nil,e,tp)
		if Duel.SpecialSummon(gc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 
		and ft>0 
		and	g:GetCount()>0 
		and Duel.SelectYesNo(tp,aux.Stringid(81190010,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--dump
function c81190010.sfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcb6)
end
function c81190010.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local dg=Duel.GetMatchingGroup(c81190010.sfilter,tp,LOCATION_DECK,0,nil)
		return dg:GetClassCount(Card.GetCode)>=3
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81190010.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81190010.sfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg1=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sg3=g:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		Duel.ConfirmCards(1-tp,sg1)
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		local cg=sg1:Select(1-tp,1,1,nil)
		local tc=cg:GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		sg1:RemoveCard(tc)
		Duel.SendtoGrave(sg1,REASON_EFFECT)
	end
end


