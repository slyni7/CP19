--헌신화 물망초-야에 사쿠라
--카드군 번호: 0xcbc
function c81230020.initial_effect(c)

	c:EnableCounterPermit(0xcbc)
	c:SetSPSummonOnce(81230020)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c81230020.mat),2,2,c81230020.mat2)
	
	--카운터 추가
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81230020,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c81230020.tg1)
	e1:SetOperation(c81230020.op1)
	c:RegisterEffect(e1)
	
	--마법/함정 카드 제외
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81230020,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c81230020.co2)
	e2:SetTarget(c81230020.tg2)
	e2:SetOperation(c81230020.op2)
	c:RegisterEffect(e2)
	
	--내성
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end

--소재 내용
function c81230020.mat(c,lc,sumtype,tp)
	return c:IsType(TYPE_EFFECT,lc,sumtype,tp) and not c:IsAttribute(ATTRIBUTE_WATER,lc,sumtype,tp)
end
function c81230020.mat2(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xcbc)
end

--카운터 추가
function c81230020.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0xcbc)
end
function c81230020.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0xcbc,4)
	end
end

--마법/함정 카드 제외
function c81230020.filter0(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xcbc)
end
function c81230020.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81230020.filter0,tp,LOCATION_GRAVE,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81230020.filter0,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81230020.filter1(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end
function c81230020.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81230020.filter1,tp,0,0x18,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,0x18)
end
function c81230020.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81230020.filter1,tp,0,0x18,nil)
	if g:GetCount()<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,1,3,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
