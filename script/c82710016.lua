--운명의 예견
function c82710016.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c82710016.con1)
	e1:SetCost(c82710016.cost1)
	e1:SetOperation(c82710016.op1)
	c:RegisterEffect(e1)
end
function c82710016.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c82710016.tfil1(c,e,tp)
	return c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c82710016.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c82710016.tfil1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c82710016.tfil1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c82710016.op1(e,tp,eg,ep,ev,re,rp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(c82710016.ocon1)
	e1:SetOperation(c82710016.oop1)
	Duel.RegisterEffect(e1,tp)
end
function c82710016.ocon1(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c82710016.oop1(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	Duel.Hint(HINT_CARD,0,82710016)
	local atk=0
	if d:GetAttack()>0 then
		atk=d:GetAttack()
	end
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end