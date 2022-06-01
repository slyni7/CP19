--블랙 블레이즈 캐논
function c95481318.initial_effect(c)
	aux.AddCodeList(c,25290459)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,95481317+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c95481318.condition)
	e1:SetTarget(c95481318.target)
	e1:SetOperation(c95481318.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95481316,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c95481318.spcost)
	e2:SetTarget(c95481318.sptg)
	e2:SetOperation(c95481318.spop)
	c:RegisterEffect(e2)
end
function c95481318.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x41) and c:IsLevelAbove(7)
end
function c95481318.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
		 and Duel.IsExistingMatchingCard(c95481318.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c95481318.filter(c,type)
	return c:IsType(type) and c:IsFaceup()
end
function c95481318.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local type=bit.band(eg:GetFirst():GetType(),0x7)
	local g=Duel.GetMatchingGroup(c95481318.filter,tp,0,LOCATION_ONFIELD,nil,type)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c95481318.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateEffect(ev) then return end
	local type=bit.band(eg:GetFirst():GetType(),0x7)
	local g=Duel.GetMatchingGroup(c95481318.filter,tp,0,LOCATION_ONFIELD,nil,type)
	Duel.Destroy(g,REASON_EFFECT)
end
function c95481318.costfilter(c,e,tp)
	if not c:IsSetCard(0x41) or not c:IsAbleToGraveAsCost() or not c:IsFaceup() then return false end
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil or class.lvup==nil then return false end
	return Duel.IsExistingMatchingCard(c95481318.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,class,e,tp)
end
function c95481318.spfilter(c,class,e,tp)
	local code=c:GetCode()
	return c:IsCode(table.unpack(class.lvup)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c95481318.cfilter(c)
	return c:IsCode(25290459) and c:IsAbleToRemoveAsCost()
end
function c95481318.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c95481318.cfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c95481318.costfilter,tp,LOCATION_MZONE+LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c95481318.costfilter,tp,LOCATION_MZONE+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local g2=Duel.SelectMatchingCard(tp,c95481318.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g2:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	Duel.Remove(g2,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetCode())
end
function c95481318.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c95481318.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	local class=_G["c"..code]
	if class==nil or class.lvup==nil then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c95481318.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,class,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		if tc:GetPreviousLocation()==LOCATION_DECK then Duel.ShuffleDeck(tp) end
	end
end