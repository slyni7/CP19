--빙탄사 플로이
--카드군 번호: 0xca3
function c81030210.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81030210,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,81030210)
	e1:SetTarget(c81030210.tg1)
	e1:SetOperation(c81030210.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--자기 소생
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81030210,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,81030210)
	e3:SetCost(c81030210.co3)
	e3:SetTarget(c81030210.tg3)
	e3:SetOperation(c81030210.op3)
	c:RegisterEffect(e3)
end

--특수 소환
function c81030210.filter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xca3)
end
function c81030210.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=0x20+0x08
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81030210.filter0,tp,zone,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,zone)
end
function c81030210.op1(e,tp,eg,ep,ev,re,r,rp)
	local zone=0x20+0x08
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81030210.filter0,tp,zone,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

--자기 소생
function c81030210.filter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xca3)
end
function c81030210.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81030210.filter1,tp,LOCATION_GRAVE,0,1,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81030210.filter1,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81030210.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return ( c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			or Duel.GetLocationCount(tp,LOCATION_SZONE)>0 )
		end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c81030210.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if c:IsRelateToEffect(e) then
		if ft1>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and ( ft2<=0 or Duel.SelectYesNo(tp,aux.Stringid(81030210,2)) ) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			c:RegisterEffect(e1)
		end
	end
end


