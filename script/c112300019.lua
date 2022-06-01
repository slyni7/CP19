--릴리 블룸메르헨(결사의 미스트사이드)
function c112300019.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),2,2,c112300019.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,112300019)
	e1:SetTarget(c112300019.target)
	e1:SetOperation(c112300019.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c112300019.atktg)
	e2:SetValue(-1000)
	c:RegisterEffect(e2)
end
function c112300019.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xc1b)
end
function c112300019.filter(c)
	return c:IsAbleToGrave()
end
function c112300019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c112300019.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c112300019.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c112300019.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c112300019.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c112300019.atktg(e,c)
	return not c:IsLinkState()
end