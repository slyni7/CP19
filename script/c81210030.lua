--FFNF(아이리스 리브레) 르 테메레르
function c81210030.initial_effect(c)

	aux.EnablePendulumAttribute(c)

	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c81210030.plimit)
	c:RegisterEffect(e2)

	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,81210031)
	e3:SetCondition(c81210030.cn3)
	e3:SetTarget(c81210030.tg3)
	e3:SetOperation(c81210030.op3)
	c:RegisterEffect(e3)
	
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetCountLimit(1,81210030)
	e4:SetTarget(c81210030.tg4)
	e4:SetOperation(c81210030.op4)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end

--plimit
function c81210030.plimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE)
	and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--replace
function c81210030.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT)
	and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
	and c:IsPreviousLocation(LOCATION_ONFIELD)
	and c:GetPreviousControler()==tp
end
function c81210030.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81210030.cfilter,1,nil,tp)
end
function c81210030.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c81210030.op3(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--summon
function c81210030.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and ( c:IsSetCard(0xcb9) or c:IsSetCard(0xcba) ) and c:IsType(TYPE_PENDULUM)
end
function c81210030.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81210030.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c81210030.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81210030.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


