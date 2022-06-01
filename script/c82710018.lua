--더 헤븐즈 로드
function c82710018.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetOperation(c82710018.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCondition(c82710018.con2)
	e2:SetCost(c82710018.cost2)
	e2:SetTarget(c82710018.tar2)
	e2:SetOperation(c82710018.op2)
	c:RegisterEffect(e2)
end
function c82710018.ofil1(c)
	return c:IsSetCard(0x5) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c82710018.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetMatchingGroup(c82710018.ofil1,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(82710018,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c82710018.nfil2(c)
	return c:IsSetCard(0x5) and c:IsLevelAbove(7) and (c:IsFaceup() or c:IsLocation(LOCATON_GRAVE))
end
function c82710018.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82710018.nfil2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function c82710018.cfil2(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function c82710018.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
			and Duel.IsExistingMatchingCard(c82710018.cfil2,tp,LOCATION_SZONE,0,1,nil,82710019)
			and Duel.IsExistingMatchingCard(c82710018.cfil2,tp,LOCATION_SZONE,0,1,nil,82710020)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c82710018.cfil2,tp,LOCATION_SZONE,0,1,1,nil,82710019)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c82710018.cfil2,tp,LOCATION_SZONE,0,1,1,nil,82710020)
	g1:Merge(g2)
	g1:AddCard(c)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c82710018.tfil2(c,e,tp)
	return c:IsSetCard(0x5) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c82710018.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c82710018.tfil2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c82710018.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82710018.tfil2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end