--월토 군청색 이글래빗
--카드군 번호: 0xca7
function c81060000.initial_effect(c)

	--세트
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81060000)
	e1:SetCost(c81060000.co1)
	e1:SetTarget(c81060000.tg1)
	e1:SetOperation(c81060000.op1)
	c:RegisterEffect(e1)
	
	--리쿠르트
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81060000,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_RELEASE)
	e2:SetCountLimit(1,81060001)
	e2:SetTarget(c81060000.tg2)
	e2:SetOperation(c81060000.op2)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81060000,1))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,81060002)
	e3:SetTarget(c81060000.tg3)
	e3:SetOperation(c81060000.op3)
	c:RegisterEffect(e3)
end

--세트
function c81060000.filter0(c)
	return c:IsReleasable() and c:IsSetCard(0xca7) and c:IsType(TYPE_MONSTER)
end
function c81060000.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81060000.filter0,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81060000.filter0,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,nil,REASON_COST)
end
function c81060000.filter1(c)
	return c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP) and ( c:IsSetCard(0xca7) or c:IsSetCard(0xca9) )
end
function c81060000.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c81060000.filter1,tp,LOCATION_DECK,0,1,nil)
	end
end
function c81060000.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SSET)
	local g=Duel.SelectMatchingCard(tp,c81060000.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
	end
end

--리쿠르트
function c81060000.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xca7) and not c:IsCode(81060000)
end
function c81060000.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81060000.filter2,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c81060000.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81060000.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--서치
function c81060000.cfilter0(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xca7) and c:IsType(TYPE_FUSION)
	and Duel.IsExistingMatchingCard(c81060000.cfilter1,tp,LOCATION_DECK,0,1,nil,c)
end
function c81060000.cfilter1(c,tc)
	return c:IsSetCard(0xca9) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc)
end
function c81060000.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81060000.cfilter0(chkc,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c81060000.cfilter0,tp,LOCATION_MZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81060000.cfilter0,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c81060000.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c81060000.cfilter1,tp,LOCATION_DECK,0,1,1,nil,tc)
	local eq=g:GetFirst()
	if eq then
		Duel.Equip(tp,eq,tc,true)
	end
end


