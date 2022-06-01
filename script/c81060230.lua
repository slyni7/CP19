--Tsukimi-Rabbit "Marudando"

function c81060230.initial_effect(c)

	--summon method
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xca7),2,2,c81060230.mfilter)
	c:EnableReviveLimit()
	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,81060230)
	e1:SetCondition(c81060230.shcn)
	e1:SetTarget(c81060230.shtg)
	e1:SetOperation(c81060230.shop)
	c:RegisterEffect(e1)
	
	--increase
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetCondition(c81060230.ic)
	e2:SetValue(3000)
	c:RegisterEffect(e2)
	
end

--summon method
function c81060230.mfilter(g,lc)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end

--search
function c81060230.shcn(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function c81060230.shtgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
	and ( c:IsSetCard(0xca8) or ( c:IsSetCard(0xca9) and c:IsType(TYPE_EQUIP) ) )
end
function c81060230.shtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81060230.shtgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function c81060230.shop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81060230.shtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--increase
function c81060230.ic(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>9
end
