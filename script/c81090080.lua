--Sanga

function c81090080.initial_effect(c)

	--summon method
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xcac),4,2,c81090080.Xyzfilter,aux.Stringid(81090080,0),3,c81090080.Xyzop)
	
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81090080)
	e1:SetCondition(c81090080.ngcn)
	e1:SetCost(c81090080.ngco)
	e1:SetTarget(c81090080.ngtg)
	e1:SetOperation(c81090080.ngop)
	c:RegisterEffect(e1)
	
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,81090081)
	e2:SetCondition(c81090080.tkcn)
	e2:SetTarget(c81090080.tktg)
	e2:SetOperation(c81090080.tkop)
	c:RegisterEffect(e2)
	
	--treat
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_RACE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetValue(0x10)
	c:RegisterEffect(e3)
	
end

--summon method
function c81090080.Xyzfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0xcac) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp) and not c:IsCode(81090080)
	and c:GetOverlayCount()==0
end
function c81090080.Xyzop(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,81090080)==0
	end
	Duel.RegisterFlagEffect(tp,81090080,RESET_PHASE+PHASE_END,0,1)
	return true
end

--negate
function c81090080.ngcn(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
	and rp~=tp
end

function c81090080.ngco(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:CheckRemoveOverlayCard(tp,1,REASON_COST)
	end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c81090080.ngtgfilter(c)
	return c:IsSetCard(0xcac) and c:IsType(TYPE_MONSTER)
end
function c81090080.ngtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return not re:GetHandler():IsStatus(STATUS_DISABLED)
		and Duel.IsExistingMatchingCard(c81090080.ngtgfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	local g=Duel.GetMatchingGroup(c81090080.ngtgfilter,tp,LOCATION_GRAVE,0,1,6,nil)
	local dam=g:GetClassCount(Card.GetAttribute)*200
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end

function c81090080.ngop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
		local g=Duel.GetMatchingGroup(c81090080.ngtgfilter,tp,LOCATION_GRAVE,0,1,6,nil)
		local dam=g:GetClassCount(Card.GetAttribute)*200
		Duel.BreakEffect()
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end

--token
function c81090080.tkcn(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE)
	and bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end

function c81090080.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81090081,0xcac,0x4011,2200,0,4,RACE_INSECT,ATTRIBUTE_DARK)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c81090080.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,81090081,0xcac,0x4011,2200,0,4,RACE_INSECT,ATTRIBUTE_DARK) then
		return
	end
	local token=Duel.CreateToken(tp,81090081)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end

	