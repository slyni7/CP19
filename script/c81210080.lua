--MNF(비시아 성좌) 르 마르스
--카드군 번호: 0xcba
function c81210080.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	--소환제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81210080.plimit)
	c:RegisterEffect(e2)
	
	--특수소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81210080,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c81210080.cn3)
	e3:SetTarget(c81210080.tg3)
	e3:SetOperation(c81210080.op3)
	c:RegisterEffect(e3)
	
	--리쿠르트
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81210080,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,81210080)
	e4:SetCondition(c81210080.cn4)
	e4:SetTarget(c81210080.tg4)
	e4:SetOperation(c81210080.op4)
	c:RegisterEffect(e4)
	if not c81210080.global_check then
		c81210080.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetLabel(81210080)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetLabel(81210080)
		Duel.RegisterEffect(ge2,0)
	end
end

--소환제약
function c81210080.plimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE)
	and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--특수소환
function c81210080.cfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_MACHINE)
end
function c81210080.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81210080.cfilter,1,nil,tp)
end
function c81210080.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c81210080.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end

--리쿠르트
function c81210080.cn4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(81210080)>0
end
function c81210080.filter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_MACHINE)
	and ( c:IsFaceup() or c:IsLocation(LOCATION_HAND) )
end
function c81210080.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_EXTRA
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)<=0 then loc=LOCATION_HAND end
	if chk==0 then
		return loc~=0
		and Duel.IsExistingMatchingCard(c81210080.filter0,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
end
function c81210080.op4(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_HAND+LOCATION_EXTRA
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)<=0 then loc=LOCATION_HAND end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81210080.filter0,tp,loc,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end


