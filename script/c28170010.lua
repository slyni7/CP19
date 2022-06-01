--감귤천사의 매혹
--Allure of Darklord
--Script by mercury233
function c28170010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,28170010+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c28170010.cost)
	e1:SetTarget(c28170010.target)
	e1:SetOperation(c28170010.activate)
	c:RegisterEffect(e1)
end

function c28170010.costfilter(c)
	return c:IsSetCard(0x2ce) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsAbleToGraveAsCost()
end
function c28170010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28170010.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c28170010.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c28170010.filter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c28170010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28170010.filter,tp,0,LOCATION_MZONE,1,nil) end
	e:SetCategory(CATEGORY_CONTROL)
end
function c28170010.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c28170010.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end