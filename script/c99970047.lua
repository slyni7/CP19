--RedHood: Wolves
function c99970047.initial_effect(c)
	
	--링크 소환
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xd34),2,2)
	c:EnableReviveLimit()
	
	--표시 형식
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_POSITION)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetCondition(c99970047.poscon)
	e11:SetTarget(c99970047.postg)
	e11:SetOperation(c99970047.posop)
	c:RegisterEffect(e11)
	
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970047,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c99970047.cost)
	e1:SetTarget(c99970047.target)
	e1:SetOperation(c99970047.operation)
	c:RegisterEffect(e1)
	
	--자가 소생
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(99970047,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c99970047.spcon)
	e2:SetTarget(c99970047.sptg)
	e2:SetOperation(c99970047.spop)
	c:RegisterEffect(e2)
	
end

--표시 형식
function c99970047.posfilter(c)
	return c:IsDefensePos() or c:IsFacedown()
end
function c99970047.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c99970047.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970047.posfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c99970047.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c99970047.posfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()==0 then return end
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
end

--특수 소환
function c99970047.cfilter(c)
	return c:IsSetCard(0xd34) and c:IsAbleToDeckAsCost()
end
function c99970047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970047.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c99970047.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c99970047.filter(c,e,tp,zone)
	return c:IsLevelBelow(4) and c:IsSetCard(0xd34) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c99970047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(c99970047.filter,tp,LOCATION_HAND,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c99970047.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c99970047.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end

--자가 소생
function c99970047.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c99970047.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99970047.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end

--모든 늑대들은 항상 무리를 짓기 마련이다.
