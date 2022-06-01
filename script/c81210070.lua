--MNF(비시아 성좌) 라스트 파이어
function c81210070.initial_effect(c)
	aux.AddCodeList(c,81210090)
	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81210070,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,81210070+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81210070.cn1)
	e1:SetTarget(c81210070.tg1)
	e1:SetOperation(c81210070.op1)
	c:RegisterEffect(e1)

	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81210070,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c81210070.co2)
	e2:SetTarget(c81210070.tg2)
	e2:SetOperation(c81210070.op2)
	c:RegisterEffect(e2)
end

--activation
function c81210070.filter(c,tp,rp)
	return c:IsSetCard(0xcb9) and c:IsPreviousPosition(POS_FACEUP)
	and c:GetPreviousControler()==tp
	and ( c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and rp==1-tp ) 
end
function c81210070.cn1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81210070.filter,1,nil,tp,rp)
end
function c81210070.filter1(c,e,tp)
	return c:IsCode(81210010) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81210070.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81210070.filter1,tp,0x01+0x02+0x10,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x02+0x10)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c81210070.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81210070.filter1,tp,0x01+0x02+0x10,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

--salvage
function c81210070.filter0(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_MACHINE)
end
function c81210070.co2(e,tp,eg,ep,ev,er,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetFlagEffect(tp,81210070)==0
		and c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.RegisterFlagEffect(tp,81210070,RESET_CHAIN,0,1)
end
function c81210070.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81210070.filter0,tp,LOCATION_EXTRA,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function c81210070.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81210070.filter0,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


