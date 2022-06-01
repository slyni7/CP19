--시산-불사귀신
--카드군 번호: 0xcbe
function c81250050.initial_effect(c)

	--패에서 발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c81250050.cn0)
	c:RegisterEffect(e0)
	
	--무효
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81250050,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81250050.co1)
	e1:SetTarget(c81250050.tg1)
	e1:SetOperation(c81250050.op1)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81250050,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81250050)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81250050.tg2)
	e2:SetOperation(c81250050.op2)
	c:RegisterEffect(e2)
end

--패에서 발동
function c81250050.filter01(c)
	return c:IsFacedown() or not c:IsSetCard(0xcbe)
end
function c81250050.filter02(c)
	return c:IsFaceup() and c:IsSetCard(0xcbe)
end
function c81250050.cn0(e)
	return Duel.GetMatchingGroupCount(c81250050.filter01,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)<=0
	and Duel.GetMatchingGroupCount(c81250050.filter02,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>0
end

--무효
function c81250050.filter1(c)
	return c:IsReleasable() and c:IsRace(RACE_ZOMBIE)
end
function c81250050.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81250050.filter1,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81250050.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(g,nil,REASON_COST)
end
function c81250050.filter2(c)
	return c:IsFaceup() and not c:IsType(TYPE_NORMAL) and not c:IsDisabled()
end
function c81250050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(c81250050.filter2,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81250050.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c81250050.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and not tc:IsDisabled() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end
end

--서치
function c81250050.cfilter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcbe) and not c:IsCode(81250050)
end
function c81250050.cfilter1(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_NORMAL) and c:IsRace(RACE_ZOMBIE)
end
function c81250050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81250050.cfilter0,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(c81250050.cfilter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81250050.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c81250050.cfilter0,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g1)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,c81250050.cfilter1,tp,LOCATION_DECK,0,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	end
end


