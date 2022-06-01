--베노퀄리아 오컬트브라
-- 0xc94
function c81264080.initial_effect(c)

	--자기 소환
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_HAND)
	e0:SetCountLimit(1,81264080)
	e0:SetCondition(c81264080.cn0)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c81264080.cn1)
	e1:SetOperation(c81264080.op1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81264081)
	e2:SetTarget(c81264080.tg2)
	e2:SetOperation(c81264080.op2)
	c:RegisterEffect(e2)
end

--자기 소환
function c81264080.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0xc94) and not c:IsCode(81264080)
end
function c81264080.cn0(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c81264080.filter0,tp,LOCATION_MZONE,0,1,nil)
end

function c81264080.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c81264080.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_SWAP_AD)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e:GetHandler():RegisterEffect(e1)
end

--특수 소환
function c81264080.spfil0(c,e,tp)
	return ( c:IsFaceup() or c:IsLocation(0x02) )
	and c:IsSetCard(0xc94) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
	and Duel.IsExistingMatchingCard(c81264080.spfil1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
	and Duel.GetMZoneCount(tp,c)>0
end
function c81264080.spfil1(c,e,tp,code)
	return c:IsSetCard(0xc94) and c:GetType()&TYPE_MONSTER+TYPE_RITUAL==TYPE_MONSTER+TYPE_RITUAL
	and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
	and not c:IsCode(code) 
end
function c81264080.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81264080.spfil0,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81264080.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g1=Duel.SelectMatchingCard(tp,c81264080.spfil0,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc1=g1:GetFirst()
	if tc1 and Duel.Release(tc1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81264080.spfil1),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,tc1:GetCode())
		if #g2>0 then
			Duel.SpecialSummon(g2,0,tp,tp,true,false,POS_FACEUP)
			if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then
				Duel.BreakEffect()
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end


