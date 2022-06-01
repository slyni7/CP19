--익스팅션 오브 프로노이아

local m=85924011
local cm=_G["c"..m]

function cm.initial_effect(c)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DAMAGE+CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.condition)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

end

function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x859) and c:IsType(TYPE_MONSTER)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x859) and c:IsType(TYPE_TUNER)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
	if not Duel.IsChainNegatable(ev) then return false end
	return re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.BreakEffect()
		Duel.Damage(tp,1000,REASON_EFFECT)
		Duel.BreakEffect()

		if Duel.GetLP(tp)>0 then

			if Duel.GetLP(tp)<=1000 then
				local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
				if #g>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
				end
			end

			if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil) then
				Duel.Recover(tp,3000,REASON_EFFECT)
			end

		end
	end
end