--시산-욕망의 늪
--카드군 번호: 0xcbe
function c81250040.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--대상 내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTarget(c81250040.tg2)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--파괴 회피
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c81250040.tg3)
	e3:SetOperation(c81250040.op3)
	c:RegisterEffect(e3)
	
	--토큰
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81250040,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,81250040)
	e4:SetCondition(c81250040.cn4)
	e4:SetTarget(c81250040.tg4)
	e4:SetOperation(c81250040.op4)
	c:RegisterEffect(e4)
end

--대상 내성
function c81250040.tg2(e,c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_NORMAL)
end

--파괴 회피
function c81250040.filter0(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xcbe)
end
function c81250040.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c81250040.filter0),tp,LOCATION_GRAVE,0,1,nil)
	end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c81250040.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81250040.filter0),tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end

--토큰
function c81250040.filter1(c,tp)
	return c:IsSetCard(0xcbe) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c81250040.cn4(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81250040.filter1,1,nil,tp)
end
function c81250040.cfilter(c)
	return c:IsSSetable(true) and c:IsSetCard(0xcbe) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(81250040)
end
function c81250040.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81250041,0xcbe,0x4011,2100,0,4,RACE_ZOMBIE,ATTRIBUTE_DARK)
		and Duel.IsExistingMatchingCard(c81250040.cfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81250040.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,81250041,0xcbe,0x4011,2100,0,4,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		local tk=Duel.CreateToken(tp,81250041)
		local og=Duel.GetMatchingGroup(c81250040.cfilter,tp,LOCATION_DECK,0,nil)
		if Duel.SpecialSummon(tk,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0
		and og:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local oc=og:Select(tp,1,1,nil)
			Duel.SSet(tp,oc:GetFirst())
		end
	end
end


