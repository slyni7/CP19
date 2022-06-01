--Star Absorber
function c99970073.initial_effect(c)

	--스타 앱소버 공격력
	local es=Effect.CreateEffect(c)
	es:SetType(EFFECT_TYPE_SINGLE)
	es:SetCode(EFFECT_UPDATE_ATTACK)
	es:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	es:SetRange(LOCATION_MZONE)
	es:SetValue(c99970073.starabsorber)
	c:RegisterEffect(es)
	
	--서치
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c99970073.cost)
	e1:SetTarget(c99970073.target)
	e1:SetOperation(c99970073.operation)
	c:RegisterEffect(e1)
	
	--공격력 감소
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c99970073.atkval)
	e3:SetCondition(c99970073.atkcon)
	c:RegisterEffect(e3)
	
end

--스타 앱소버 공격력
function c99970073.starabsorber(e,c)
	return c:GetLevel()*100
end

--서치
function c99970073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1051,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1051,2,REASON_COST)
end
function c99970073.filter(c)
	return c:IsSetCard(0xd36) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c99970073.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970073.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c99970073.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c99970073.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--공격력 감소
function c99970073.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1051)*-100
end
function c99970073.atkcon(e)
	return e:GetHandler():GetLevel()~=e:GetHandler():GetOriginalLevel()
end
