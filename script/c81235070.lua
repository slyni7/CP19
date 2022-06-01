--영겁의 야상곡
--카드군 번호: 0xc90
function c81235070.initial_effect(c)

	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81235070,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c81235070.tg1)
	e1:SetOperation(c81235070.op1)
	c:RegisterEffect(e1)
	
	--발동제한
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81235070.cn2)
	e2:SetTarget(c81235070.tg2)
	e2:SetTargetRange(0,LOCATION_SZONE)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81235070,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,81235070)
	e3:SetTarget(c81235070.tg3)
	e3:SetOperation(c81235070.op3)
	c:RegisterEffect(e3)
end

--특수소환
function c81235070.filter0(c,e,tp)
	return c:IsSetCard(0xc90) and c:GetAttribute()==ATTRIBUTE_DARK
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81235070.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81235070.filter0,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c81235070.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81235070.filter0,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--발동제한
function c81235070.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xc90) and c:GetAttribute()==ATTRIBUTE_DARK
end
function c81235070.cn2(e)
	return Duel.IsExistingMatchingCard(c81235070.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c81235070.tg2(e,c)
	return c:IsFacedown()
end

--서치
function c81235070.cfilter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc90) and c:GetAttribute()==ATTRIBUTE_DARK
end
function c81235070.cfilter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc90) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81235070.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81235070.cfilter0,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c81235070.cfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c81235070.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c81235070.cfilter0,tp,LOCATION_DECK,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,c81235070.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()>1 then
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	end
end


