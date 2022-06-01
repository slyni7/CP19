--Melodevil Notes Nihill
function c81150070.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81150070,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81150070+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81150070.co)
	e1:SetTarget(c81150070.tg)
	e1:SetOperation(c81150070.op)
	c:RegisterEffect(e1)
	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81150070,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c81150070.vco)
	e2:SetTarget(c81150070.vtg)
	e2:SetOperation(c81150070.vop)
	c:RegisterEffect(e2)
end

--activate
function c81150070.filter(c)
	return c:IsReleasable() and c:IsSetCard(0xcb2) and c:IsType(TYPE_MONSTER)
	and ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() and c:IsLocation(LOCATION_MZONE) )
end
function c81150070.co(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_MZONE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81150070.filter,tp,loc,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81150070.filter,tp,loc,0,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
end

function c81150070.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsOnField()
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81150070.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--summon
function c81150070.vco(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToRemoveAsCost()
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c81150070.filter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and c:IsType(TYPE_MONSTER) and c:IsSetCard(0xcb2)
end
function c81150070.vtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81150070.filter2(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81150070.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81150070.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81150070.vop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return false
	end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
