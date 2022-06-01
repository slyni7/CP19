--IJN 아야나미
function c81190110.initial_effect(c)

	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)

	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c81190110.lm1)
	c:RegisterEffect(e1)
	
	--덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81190110,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,81190110)
	e2:SetTarget(c81190110.tg2)
	e2:SetOperation(c81190110.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81190110,2))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,81190111)
	e4:SetTarget(c81190110.tg4)
	e4:SetOperation(c81190110.op4)
	c:RegisterEffect(e4)
end

--splimit
function c81190110.lm1(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xcb6)
end

--salvage
function c81190110.filter1(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb6) 
end
function c81190110.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190110.filter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81190110.filter2(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsSetCard(0xcb6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81190110.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81190110.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local cg=Duel.GetMatchingGroup(c81190110.filter2,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cg:GetCount()>0
	and Duel.SelectYesNo(tp,aux.Stringid(81190110,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=cg:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end

--draw
function c81190110.filter3(c)
	return c:IsAbleToRemove() 
	and ( c:IsType(TYPE_SPIRIT) or c:IsSetCard(0xcb6) and c:IsType(TYPE_SPELL+TYPE_TRAP) )
end
function c81190110.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190110.filter3,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81190110.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81190110.filter3,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end


