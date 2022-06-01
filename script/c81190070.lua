--IJN 진츠
function c81190070.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2,c81190070.lmat)
	
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81190070,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81190070)
	e2:SetCost(c81190070.co2)
	e2:SetTarget(c81190070.tg2)
	e2:SetOperation(c81190070.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(81190070,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetTarget(c81190070.tg3)
	e3:SetOperation(c81190070.op3)
	c:RegisterEffect(e3)
end

--링크 소재
function c81190070.lmat(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xcb6)
end

--summon
function c81190070.filter2(c,g)
	return g:IsContains(c) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c81190070.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,c81190070.filter2,1,nil,lg)
	end
	local g=Duel.SelectReleaseGroup(tp,c81190070.filter2,1,1,nil,lg)
	Duel.Release(g,REASON_COST)
	e:SetValue(g:GetFirst():GetCode())
end
--summon
function c81190070.filter3(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0xcb6) and c:IsType(TYPE_SPIRIT)
end
function c81190070.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local code=e:GetValue()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c81190070.filter3,tp,LOCATION_HAND,0,1,nil,code)
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81190070.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local code=e:GetValue()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81190070.filter3,tp,LOCATION_HAND,0,1,1,nil,code)
	if g:GetCount()>0 then
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
--spsummon
function c81190070.filter4(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsSetCard(0xcb6) and c:IsType(TYPE_SPIRIT)
end
function c81190070.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local code=e:GetValue()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c81190070.filter4,tp,LOCATION_HAND,0,1,code,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81190070.op3(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetValue()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c81190070.filter4,tp,LOCATION_HAND,0,1,1,code,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


