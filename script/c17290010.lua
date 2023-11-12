--파이널 시그널
function c17290010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1,17290010+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17290010.tg1)
	e1:SetOperation(c17290010.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17290010,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetCondition(c17290010.con2)
	e2:SetTarget(c17290010.tg2)
	e2:SetOperation(c17290010.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMONABLE_CARD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c17290010.tg2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	e4:SetCondition(c17290010.con4)
	e4:SetTarget(c17290010.tg2)
	c:RegisterEffect(e4)
end
function c17290010.con4(e,c)
	if not c then
		return true
	end
	return false
end
function c17290010.tfilter11(c,e,tp,m)
	if not c:IsSetCard(0x8) or not c:IsSetCard(0x2c3) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		return false
	end
	local mg=m:Clone()
	mg:RemoveCard(c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		return mg:CheckWithSumGreater(c17290010.tfunction1,c:GetLevel(),c)
	else
		return mg:IsExists(c17290010.tfilter13,1,nil,tp,mg,c)
	end
end
function c17290010.tfunction1(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetRitualLevel(rc)
	end
end
function c17290010.tfilter12(c,e,tp)
	return (c:IsFaceup() or c:IsControler(tp)) and c:IsReleasable() and not c:IsImmuneToEffect(e)
end
function c17290010.tfilter13(c,tp,m,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return m:CheckWithSumGreater(c17290010.tfunction1,rc:GetLevel(),rc)
	else
		return false
	end
end
function c17290010.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local m1=Duel.GetRitualMaterial(tp)
		local m2=Duel.GetMatchingGroup(c17290010.tfilter12,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
		m1:Merge(m2)
		return Duel.IsExistingMatchingCard(c17290010.tfilter11,tp,LOCATION_HAND,0,1,nil,e,tp,m1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c17290010.op1(e,tp,eg,ep,ev,re,r,rp)
	local m1=Duel.GetRitualMaterial(tp)
	local m2=Duel.GetMatchingGroup(c17290010.tfilter12,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	m1:Merge(m2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c17290010.tfilter11,tp,LOCATION_HAND,0,1,1,nil,e,tp,m1)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		m1:RemoveCard(tc)
		if tc.mat_filter then
			m1=m1:Filter(tc.mat_filter,nil)
		end
		local mat=nil
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=m1:SelectWithSumGreater(tp,c17290010.tfunction1,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=m1:FilterSelect(tp,c17290010.tfilter13,1,1,nil,tp,m1,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=m1:SelectWithSumGreater(tp,c17290010.tfunction1,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c17290010.con2(e,c)
	if c==nil then
		return e:GetHandler():IsAbleToRemove()
	end
	local tp=c:GetControler()
	local m=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and m:CheckWithSumGreater(c17290010.tfunction1,c:GetLevel(),c)
end
function c17290010.tg2(e,c)
	if type(c)=="Card" then
		return c:IsSetCard(0x2c3)
	else
		return true
	end
end
function c17290010.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local m=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mat=m:SelectWithSumGreater(tp,c17290010.tfunction1,c:GetLevel(),c)
	mat:AddCard(e:GetHandler())
	c:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_COST+REASON_RITUAL+REASON_MATERIAL+REASON_SUMMON)
end