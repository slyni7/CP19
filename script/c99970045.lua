--RedHood: Hunting
function c99970045.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(99970045,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c99970045.spcon)
	e1:SetTarget(c99970045.sptg)
	e1:SetOperation(c99970045.spop)
	e1:SetCost(c99970045.spcost)
	e1:SetCountLimit(1,99970045)
	c:RegisterEffect(e1)
	
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(99970045,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c99970045.destg)
	e3:SetOperation(c99970045.desop)
	c:RegisterEffect(e3)
	
	--관통 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c99970045.cost)
	e2:SetCondition(c99970045.condition)
	e2:SetOperation(c99970045.activate)
	c:RegisterEffect(e2)
	
end

--특수 소환
function c99970045.cfilter(c)
	return c:IsSetCard(0xd34) and c:IsAbleToDeckAsCost()
end
function c99970045.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970045.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c99970045.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c99970045.cfilter1(c)
	return c:IsSetCard(0xd34) and c:IsFaceup()
end
function c99970045.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.IsExistingMatchingCard(c99970045.cfilter1,tp,LOCATION_MZONE,0,1,nil)
end
function c99970045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ev)
end
function c99970045.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Damage(1-tp,ev,REASON_EFFECT)
	end
end

--파괴
function c99970045.check(c,tp)
	return c and c:IsControler(tp) and c:IsSetCard(0xd34)
end
function c99970045.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetAttackTarget()~=nil
		and (c99970045.check(Duel.GetAttacker(),tp) or c99970045.check(Duel.GetAttackTarget(),tp)) end
	if c99970045.check(Duel.GetAttacker(),tp) then
		Duel.SetTargetCard(Duel.GetAttackTarget())
	else
		Duel.SetTargetCard(Duel.GetAttacker())
	end
end
function c99970045.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--관통 부여
function c99970045.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c99970045.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c99970045.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xd34))
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

--붉게 물든 소녀는 원수의 피만을 갈망한다.
