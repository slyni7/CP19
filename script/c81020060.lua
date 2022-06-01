--soboku: 만드라코네

function c81020060.initial_effect(c)

	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81020060+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81020060.spco)
	e1:SetTarget(c81020060.sptg)
	e1:SetOperation(c81020060.spop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(81020060,ACTIVITY_SPSUMMON,c81020060.cunfilter)

	--immune spell
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c81020060.filter)
	c:RegisterEffect(e2)

	--immune trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81020060,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1)
	e3:SetCost(c81020060.co)
	e3:SetTarget(c81020060.tg)
	e3:SetOperation(c81020060.op)
	c:RegisterEffect(e3)
	
end

--special summon
function c81020060.cunfilter(c)
	return c:IsSetCard(0xca2)
end
function c81020060.spco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(81020060,tp,ACTIVITY_SPSUMMON)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c81020060.splm)
	Duel.RegisterEffect(e1,tp)
end
function c81020060.splm(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xca2)
end

function c81020060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81020060,0xca2,0x21,3,1300,800,RACE_PLANT,ATTRIBUTE_WIND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c81020060.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) 
	and Duel.IsPlayerCanSpecialSummonMonster(tp,81020060,0xca2,0x21,3,1300,800,RACE_PLANT,ATTRIBUTE_WIND) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end

--immune spell
function c81020060.filter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--summon
function c81020060.cof(c,tp)
	return c:IsAbleToRemoveAsCost() and c:GetType()==0x2
	and Duel.IsExistingMatchingCard(c81020060.tgf,tp,0x10,0,1,nil,tp)
end
function c81020060.co(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81020060.cof,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81020060.cof,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c81020060.tgf(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0xca2)
	and ( c:IsCode(81020000) or c:IsCode(81020010) or c:IsCode(81020020) or c:IsCode(81020030) or c:IsCode(81020070) or c:IsCode(81020180)  )
	and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0xca2,0x21,0,0,0,RACE_PLANT,ATTRIBUTE_WIND)
end
function c81020060.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81020060.tgf,tp,LOCATION_GRAVE,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function c81020060.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	local g=Duel.GetMatchingGroup(c81020060.tgf,tp,LOCATION_GRAVE,0,nil,tp)
	if g:GetCount()<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tg=sg:GetFirst()
	local fid=e:GetHandler():GetFieldID()
	while tg do
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tg:RegisterEffect(e1,true)
		tg:RegisterFlagEffect(81020060,RESET_EVENT+0x47c0000,0,1,fid)
		tg=sg:GetNext()
	end
	Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	sg:KeepAlive()
end
