--펑크랙 포트리스 드래곤
--카드군 번호: 0xcbf
function c81260000.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c81260000.mat),2)
	
	--제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	
	--대상내성
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c81260000.cn2)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--발동무효
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81180120,0))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c81260000.cn3)
	e3:SetTarget(c81260000.tg3)
	e3:SetOperation(c81260000.op3)
	c:RegisterEffect(e3)
	
	--특수소환
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81260000,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,81260000)
	e4:SetCondition(c81260000.cn4)
	e4:SetTarget(c81260000.tg4)
	e4:SetOperation(c81260000.op4)
	c:RegisterEffect(e4)
end

--소재
function c81260000.mat(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
end

--대상내성
function c81260000.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end

--발동무효
function c81260000.cn3(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev)
	and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c81260000.filter0(c)
	return c:IsSetCard(0xcbf) and ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() )
end
function c81260000.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81260000.filter0,tp,0x02+0x0c,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,0x02+0x0c)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81260000.op3(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(c81260000.filter0,tp,0x02+0x0c,0,nil)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 
	and mg:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=mg:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

--특수소환
function c81260000.cn4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c81260000.sfil(c,e,tp)
	return c:IsSetCard(0xcbf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81260000.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81260000.sfil,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function c81260000.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c81260000.sfil),tp,LOCATION_GRAVE,0,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or #g<=0 then
		return
	end
	local ct=math.min(ft,3)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
