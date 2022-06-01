--USS(이글 유니온) 에식스
function c81170140.initial_effect(c)
	
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c81170140.mfilter),2,3)
	
	--Link
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81170140,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81170140)
	e1:SetCondition(c81170140.cn1)
	e1:SetTarget(c81170140.tg1)
	e1:SetOperation(c81170140.op1)
	c:RegisterEffect(e1)
	
	--status
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81170140,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81170141)
	e2:SetCost(c81170140.co2)
	e2:SetTarget(c81170140.tg2)
	e2:SetOperation(c81170140.op2)
	c:RegisterEffect(e2)
end

--material
function c81170140.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_MACHINE)
end

--Link
function c81170140.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c81170140.filter1(c)
	return c:IsAbleToRemove() and c:IsRace(RACE_MACHINE)
	and ( c:IsFaceup() or c:IsLocation(LOCATION_HAND) )
end
function c81170140.filter2(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
	and c:IsSetCard(0xcb4) and c:IsLevelBelow(4)
end
function c81170140.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local zone=c:GetLinkedZone(tp)
		return zone~=0
		and Duel.IsExistingMatchingCard(c81170140.filter1,tp,0x12,0,1,c)
		and Duel.IsExistingMatchingCard(c81170140.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x12)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81170140.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if zone==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81170140.filter1,tp,0x12,0,1,1,c)
	if g:GetCount()>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c81170140.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(c81170140.lm1)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81170140.lm1(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end

--status
function c81170140.filter3(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xcb4)
end
function c81170140.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81170140.filter3,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81170140.filter3,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81170140.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetChainLimit(c81170140.lm2)
end
function c81170140.lm2(e,ep,tp)
	return tp==ep
end
function c81170140.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end


