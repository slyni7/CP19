--시산-독조의 술
--카드군 번호: 0xcbe
function c81250030.initial_effect(c)

	--릴리스
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81250030,0))
	e1:SetCategory(CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81250030.co1)
	e1:SetTarget(c81250030.tg1)
	e1:SetOperation(c81250030.op1)
	c:RegisterEffect(e1)
	
	--소생
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81250030,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81250030)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81250030.tg2)
	e2:SetOperation(c81250030.op2)
	c:RegisterEffect(e2)
end

--릴리스
function c81250030.filter0(c)
	return c:IsAbleToRemoveAsCost()
	and ( ( c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_NORMAL) ) or ( c:IsSetCard(0xcbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) ) )
end
function c81250030.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81250030.filter0,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81250030.filter0,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81250030.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,0,tp,LOCATION_MZONE)
end
function c81250030.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0,LOCATION_MZONE,1,2,nil)
	if g:GetCount()>0 then
		Duel.Release(g,REASON_EFFECT)
	end
end

--특수 소환
function c81250030.cfilter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_NORMAL) and c:IsRace(RACE_ZOMBIE)
end
function c81250030.cfilter1(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xcbe)
end
function c81250030.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81250030.cfilter0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81250030.cfilter0,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c81250030.cfilter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81250030.cfilter0,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81250030.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c81250030.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end


