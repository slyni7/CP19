--아바레미야타이코

function c81070070.initial_effect(c)
	
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c81070070.atcn)
	c:RegisterEffect(e2)
	
	--trap set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,81070070)
	e3:SetCondition(c81070070.tscn)
	e3:SetOperation(c81070070.tsop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c81070070.tscn2)
	c:RegisterEffect(e4)
	
end

--activate
function c81070070.atcnfilter(c)
	return c:IsFaceup() 
	   and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
end
function c81070070.atcn(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetMatchingGroupCount(c81070070.atcnfilter,tp,LOCATION_ONFIELD,0,nil)==0
end

--trap set
function c81070070.tscn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0)
	   and re:GetHandler():IsSetCard(0xcaa)
end
function c81070070.tscn2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetPreviousControler()==tp
end

function c81070070.tsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c81070070.atscn)
	e1:SetOperation(c81070070.atsop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c81070070.atscnfilter(c)
	return c:IsSSetable(true)
	   and ( c:IsSetCard(0xcaa) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) )
	   and not c:IsCode(81070070)
end
function c81070070.atscn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81070070.atscnfilter,tp,LOCATION_DECK,0,1,nil)
end

function c81070070.atsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c81070070.atscnfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
