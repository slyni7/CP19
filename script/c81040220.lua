function c81040220.initial_effect(c)

	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xca4),2,2)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c81040220.dmtg)
	e1:SetOperation(c81040220.dmop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81040220)
	e2:SetCondition(c81040220.sccn)
	e2:SetTarget(c81040220.sctg)
	e2:SetOperation(c81040220.scop)
	c:RegisterEffect(e2)
	if not c81040220.global_check then
		c81040220.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c81040220.gcop)
		Duel.RegisterEffect(ge1,0)
	end
end

--damage
function c81040220.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,500)
end

function c81040220.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

--set a card
function c81040220.gcop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0xca4) then
		Duel.RegisterFlagEffect(rp,81040220,RESET_PHASE+PHASE_END,0,1)
	end
end

function c81040220.sccn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,81040220)~=0
end

function c81040220.filter(c)
	return c:IsSSetable(true) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xca4)
end
function c81040220.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81040220.filter,tp,0x01+0x10,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	end
end

function c81040220.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c81040220.filter),tp,0x01+0x10,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc and not Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then
		return
	end
	Duel.SSet(tp,tc)
end

