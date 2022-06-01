--시산-혼 소생의 술
--카드군 번호: 0xcbe
function c81250060.initial_effect(c)

	--패에서 발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81250060.cn0)
	c:RegisterEffect(e0)
	
	--카운터
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c81250060.cn1)
	e1:SetCost(c81250060.co1)
	e1:SetTarget(c81250060.tg1)
	e1:SetOperation(c81250060.op1)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81250060,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81250060)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81250060.tg2)
	e2:SetOperation(c81250060.op2)
	c:RegisterEffect(e2)
end

--패에서 발동
function c81250060.filter01(c)
	return c:IsFacedown() or not c:IsSetCard(0xcbe)
end
function c81250060.filter02(c)
	return c:IsFaceup() and c:IsSetCard(0xcbe)
end
function c81250060.cn0(e)
	return Duel.GetMatchingGroupCount(c81250060.filter01,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)<=0
	and Duel.GetMatchingGroupCount(c81250060.filter02,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>0
end

--카운터
function c81250060.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev)
end
function c81250060.filter0(c)
	return c:IsReleasable() and c:IsType(TYPE_NORMAL) and c:IsRace(RACE_ZOMBIE)
end
function c81250060.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81250060.filter0,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81250060.filter0,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,nil,REASON_COST)
end
function c81250060.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetChainLimit(c81250060.lim)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c81250060.lim(e,lp,tp)
	return lp==tp
end
function c81250060.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--서치
function c81250060.cfilter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcbe) and not c:IsCode(81250060)
end
function c81250060.cfilter1(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_NORMAL) and c:IsRace(RACE_ZOMBIE)
end
function c81250060.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81250060.cfilter0,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c81250060.cfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81250060.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c81250060.cfilter0,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g1)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c81250060.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	end
end


