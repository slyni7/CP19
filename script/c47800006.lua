--호기심 많은 사적뿌리
function c47800006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,47800006)
	e1:SetCondition(c47800006.spcon)
	c:RegisterEffect(e1)

	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,47800007)
	e2:SetCondition(c47800006.condition)
	e2:SetTarget(c47800006.thtg)
	e2:SetOperation(c47800006.thop)
	c:RegisterEffect(e2)
end

function c47800006.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800006.spcon(e,c,tp)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c47800006.filter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c47800006.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0)<=120
end
function c47800006.thfilter(c)
	return c:IsAbleToHand()
end
function c47800006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c47800006.thfilter,tp,0,LOCATION_DECK,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c47800006.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c47800006.thfilter,tp,0,LOCATION_DECK,nil)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local sg=g:RandomSelect(tp,3)
		Duel.ConfirmCards(tp,sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
		local tg=sg:Select(tp,1,1,nil)
		local t=tg:GetFirst():GetCode()
		local token=Duel.CreateToken(tp,t)
		Duel.SendtoHand(token,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,token)
		Duel.ShuffleDeck(1-tp)
	end
end