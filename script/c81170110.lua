--USS 몬트필리어
function c81170110.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,2,c81170110.mat0)
	
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81170110,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81170110)
	e1:SetTarget(c81170110.tg1)
	e1:SetOperation(c81170110.op1)
	c:RegisterEffect(e1)
	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81170110,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81170110.cn2)
	e2:SetTarget(c81170110.tg2)
	e2:SetOperation(c81170110.op2)
	c:RegisterEffect(e2)
end

--링크 소환
function c81170110.mat0(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xcb4)
end

--spsummon
function c81170110.filter1(c,e,tp,zone)
	return c:IsLevelBelow(5) and c:IsSetCard(0xcb4)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK,tp,zone)
end
function c81170110.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)
		local loc=LOCATION_HAND+LOCATION_GRAVE
		return zone~=0 and Duel.IsExistingMatchingCard(c81170110.filter1,tp,loc,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c81170110.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	if zone==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81170110.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)
	end
end

--negate
function c81170110.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>PHASE_MAIN1 and ph<PHASE_MAIN2 and tp~=ep and Duel.IsChainNegatable(ev)
end
function c81170110.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81170110.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) 
	and Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.SelectYesNo(tp,aux.Stringid(81170110,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dc=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		local sc=dc:Select(tp,1,1,nil)
		if sc then
			Duel.HintSelection(sc)
			Duel.Destroy(sc,REASON_EFFECT)
		end
	end
end


