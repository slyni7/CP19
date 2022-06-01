--파이널 일루미네이션
function c17290008.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCountLimit(1,17290008+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17290008.tg1)
	e1:SetOperation(c17290008.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17290008,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetCondition(c17290008.con2)
	e2:SetTarget(c17290008.tg2)
	e2:SetOperation(c17290008.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMONABLE_CARD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c17290008.tg2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	e4:SetCondition(c17290008.con4)
	e4:SetTarget(c17290008.tg2)
	c:RegisterEffect(e4)
end
function c17290008.con4(e,c)
	if not c then
		return true
	end
	return false
end
function c17290008.tfilter1(c,e,tp,m)
	if not c:IsSetCard(0x8) or not c:IsSetCard(0x2c3) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		return false
	end
	local mg=m:Clone()
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumGreater(c17290008.tfunction1,c:GetLevel(),c)
end
function c17290008.tfunction1(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetRitualLevel(rc)
	end
end
function c17290008.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
			return false
		end
		local m=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil)
		return Duel.IsExistingMatchingCard(c17290008.tfilter1,tp,LOCATION_HAND,0,1,nil,e,tp,m)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c17290008.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	local m=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c17290008.tfilter1,tp,LOCATION_HAND,0,1,1,nil,e,tp,m)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			m=m:Filter(tc.mat_filter,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local mat=m:SelectWithSumGreater(tp,c17290008.tfunction1,tc:GetLevel(),tc)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_RITUAL+REASON_MATERIAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c17290008.con2(e,c)
	if c==nil then
		return e:GetHandler():IsAbleToRemove()
	end
	local tp=c:GetControler()
	local m=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and m:CheckWithSumGreater(c17290008.tfunction1,c:GetLevel(),c)
end
function c17290008.tg2(e,c)
	return c:IsSetCard(0x2c3)
end
function c17290008.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local m=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mat=m:SelectWithSumGreater(tp,c17290008.tfunction1,c:GetLevel(),c)
	mat:AddCard(e:GetHandler())
	c:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_COST+REASON_RITUAL+REASON_MATERIAL+REASON_SUMMON)
end