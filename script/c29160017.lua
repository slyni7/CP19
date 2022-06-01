--유혹의 펜듈럼디스코
function c29160017.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c29160017.condition)
	e1:SetTarget(c29160017.target)
	e1:SetOperation(c29160017.activate)
	c:RegisterEffect(e1)
end
function c29160017.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c7)
end
function c29160017.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c29160017.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c29160017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,LOCATION_PZONE)>0 end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c29160017.thfilter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x2c7) and c:IsAbleToHand()
end
function c29160017.thfilter2(c)
	return c:IsCode(29160017) and c:IsAbleToHand()
end
function c29160017.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,LOCATION_PZONE)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	local hg1=Duel.GetMatchingGroup(c29160017.thfilter1,tp,LOCATION_DECK,0,nil)
	if ct>=1 and hg1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29160017,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg1=hg1:Select(tp,1,1,nil)
		Duel.SendtoHand(shg1,nil,REASON_EFFECT+REASON_DESTROY)
		Duel.ConfirmCards(1-tp,shg1)
	end
	local hg2=Duel.GetMatchingGroup(c29160017.thfilter2,tp,LOCATION_DECK,0,nil)
	if ct>=2 and hg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29160017,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local shg2=hg2:Select(tp,1,1,nil)
		Duel.SendtoHand(shg2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,shg2)
	end
	local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if ct>=3 and rg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29160017,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local srg=rg:Select(tp,1,1,nil)
		Duel.Remove(srg,POS_FACEUP,REASON_EFFECT)
	end
end