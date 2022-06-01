--펑크랙 드레이크
--카드군 번호: 0xcbf
function c81260050.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c81260050.mat),1)
	
	--대상내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81260050.cn1)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	
	--제거
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81260050,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c81260050.tg2)
	e2:SetOperation(c81260050.op2)
	c:RegisterEffect(e2)
	
	--특수소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81260050,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,81260050)
	e3:SetCondition(c81260050.cn3)
	e3:SetTarget(c81260050.tg3)
	e3:SetOperation(c81260050.op3)
	c:RegisterEffect(e3)
end

--소재
function c81260050.mat(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end

--대상내성
function c81260050.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end

--제거
function c81260050.filter0(c)
	return c:IsSetCard(0xcbf) and ( c:IsFaceup() or c:IsLocation(LOCATION_HAND) )
end
function c81260050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81260050.filter0,tp,0x02+0x0c,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x02+0x0c)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c81260050.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c81260050.filter0,tp,0x02+0x0c,0,1,1,nil)
	local d=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if d:GetCount()>0 and g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=d:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

--특수소환
function c81260050.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c81260050.sfil(c,e,tp)
	return c:IsSetCard(0xcbf) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81260050.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81260050.sfil,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function c81260050.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c81260050.sfil),tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or #g<=0 then
		return
	end
	local ct=math.min(ft,2)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
