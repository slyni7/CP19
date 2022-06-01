--펑크랙 프레임
--카드군 번호: 0xcbf
function c81260020.initial_effect(c)

	c:EnableReviveLimit()
	
	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c81260020.mcn)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81260020,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c81260020.cn2)
	e2:SetTarget(c81260020.tg2)
	e2:SetOperation(c81260020.op2)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81260020,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,81260020)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c81260020.tg3)
	e3:SetOperation(c81260020.op3)
	c:RegisterEffect(e3)
end

--특수소환
function c81260020.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf) and not c:IsCode(81260020)
end
function c81260020.mcn(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c81260020.filter0,tp,LOCATION_MZONE,0,1,nil)
end

--파괴
function c81260020.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c81260020.filter1(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcbf)
end
function c81260020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81260020.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c81260020.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81260020.filter1,tp,LOCATION_DECK,0,1,1,nil)
	local d=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and d:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=d:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

--서치
function c81260020.cfilter(c)
	return c:IsSetCard(0xcbf) and not c:IsCode(81260020)
	and ( c:IsAbleToHand() or c:IsAbleToGrave() )
end
function c81260020.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81260020.cfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81260020.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(81260020,1))
	local g=Duel.SelectMatchingCard(tp,c81260020.cfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if g then
		if g:IsAbleToGrave() and ( not g:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(81260020,2)) ) then
			Duel.SendtoGrave(g,REASON_EFFECT)
		else
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end


