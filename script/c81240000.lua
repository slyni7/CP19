--중장 토끼-채리엇
--카드군 번호: 0xcbd
function c81240000.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,81240000)
	e1:SetCondition(c81240000.cn1)
	e1:SetOperation(c81240000.op1)
	c:RegisterEffect(e1)
	
	--프리체인
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81240000,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c81240000.co2)
	e2:SetTarget(c81240000.tg2)
	e2:SetOperation(c81240000.op2)
	c:RegisterEffect(e2)
end

--특수 소환
function c81240000.cn1(e,c)
	if c==nil then
		return true
	end
	return Duel.GetCustomActivityCount(81240000,tp,ACTIVITY_SPSUMMON)==0
end
function c81240000.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(c81240000.lm1)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81240000.lm1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xcbd)
end

--프리체인
function c81240000.filter0(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xcbd) and c:IsType(TYPE_UNION)
end
function c81240000.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81240000.filter0,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81240000.filter0,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81240000.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return true
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81240000.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


