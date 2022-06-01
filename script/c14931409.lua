--sakura karin
function c14931409.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,14931409)
	e1:SetTarget(c14931409.sptg)
	e1:SetOperation(c14931409.spop)
	c:RegisterEffect(e1)
	--counter card
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,149314091)
	e2:SetCondition(c14931409.condition)
	e2:SetCost(c14931409.cost)
	e2:SetTarget(c14931409.distg)
	e2:SetOperation(c14931409.disop)
	c:RegisterEffect(e2)
end
function c14931409.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c14931409.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c14931409.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xb93)
end
function c14931409.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev) and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c14931409.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c14931409.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c14931409.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c14931409.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) then
	Duel.Draw(1-tp,1,REASON_EFFECT)
	end
end