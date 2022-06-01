--MNF 르 말랑
--카드군 번호: 0xcba
function c81210130.initial_effect(c)

	aux.EnablePendulumAttribute(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(c81210130.mat),1)

	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81210130.plimit)
	c:RegisterEffect(e2)
	
	--내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c81210130.ve3)
	c:RegisterEffect(e3)
	--local e4=e3:Clone()
	--e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--c:RegisterEffect(e4)
	
	--펜듈럼 존으로
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c81210130.cn5)
	e5:SetTarget(c81210130.tg5)
	e5:SetOperation(c81210130.op5)
	c:RegisterEffect(e5)
	
	--소환 성공시
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetCountLimit(1,81210130)
	e6:SetCondition(c81210130.cn6)
	e6:SetTarget(c81210130.tg6)
	e6:SetOperation(c81210130.op6)
	c:RegisterEffect(e6)
	
	--싱크로 소환
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCountLimit(1,81210131)
	e7:SetCost(c81210130.co7)
	e7:SetTarget(c81210130.tg7)
	e7:SetOperation(c81210130.op7)
	c:RegisterEffect(e7)
end

--plimit
function c81210130.plimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE)
	and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--싱크로
function c81210130.mat(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end

--내성
function c81210130.ve3(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end

--펜듈럼 존으로
function c81210130.cn5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and c:IsPreviousLocation(LOCATION_MZONE)
	and c:IsFaceup()
end
function c81210130.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	end
end
function c81210130.op5(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end

--소환 성공시
function c81210130.cn6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO) or c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c81210130.tgroup(c)
	return c:IsFaceup() and c:IsSetCard(0xcb9)
end
function c81210130.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c81210130.tgroup,tp,LOCATION_MZONE,0,nil)
		return ct>0	and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,0x10+0x0c,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x10+0x0c)
end
function c81210130.op6(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c81210130.tgroup,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,0x10+0x0c,nil)
	if ct>0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg=g:Select(tp,1,ct,nil)
		Duel.HintSelection(dg)
		Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
	end
end

--싱크로 소환
function c81210130.relgoal(sg,tp)
	Duel.SetSelectedCard(sg)
	if sg:CheckWithSumGreater(Card.GetLevel,7) and Duel.GetMZoneCount(tp,sg)>0 then
		Duel.SetSelectedCard(sg)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else
		return false
	end
end
function c81210130.co7(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetReleaseGroup(tp):Filter(Card.IsType,nil,TYPE_MONSTER)
	if chk==0 then
		return mg:CheckSubGroup(c81210130.relgoal,1,7,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,c81210130.relgoal,false,1,7,tp)
	Duel.Release(sg,REASON_COST)
end
function c81210130.tg7(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,true,false)
	end
end
function c81210130.op7(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.SpecialSummon(c,SUMMON_TYPE_SYNCHRO,tp,tp,true,false,POS_FACEUP)
end
