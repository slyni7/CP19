--베노퀄리아 렙트로베이트
--카드군 번호: 0xc94

function c81264050.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81264050.tg1)
	e1:SetOperation(c81264050.op1)
	c:RegisterEffect(e1)
	
	--묘지 회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81264050)
	e2:SetCondition(c81264050.cn2)
	e2:SetCost(c81264050.co2)
	e2:SetTarget(c81264050.tg2)
	e2:SetOperation(c81264050.op2)
	c:RegisterEffect(e2)
end

--발동
function c81264050.exfilter0(c)
	return c:IsSetCard(0xc94) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c81264050.filter0(c,e,tp,m)
	if not c:IsSetCard(0xc94) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		return false
	end
	local mg=m:Clone()
	mg:RemoveCard(c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil,tp)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	else
		return mg:IsExists(c81264050.filter1,1,nil,tp,mg,c)
	end
end
function c81264050.filter1(c,tp,m,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return m:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else
		return false
	end
end
function c81264050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:IsLocation(LOCATION_HAND) and 3 or 2
	if chk==0 then
		local m=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_REPTILE)
		if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=ct then
			local g=Duel.GetMatchingGroup(c81264050.exfilter0,tp,LOCATION_DECK,0,nil)
			m:Merge(g)
		end
		return Duel.IsExistingMatchingCard(c81264050.filter0,tp,LOCATION_HAND,0,1,nil,e,tp,m)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c81264050.op1(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp):Filter(Card.IsRace,nil,RACE_REPTILE)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then
		local g=Duel.GetMatchingGroup(c81264050.exfilter0,tp,LOCATION_DECK,0,nil)
		m:Merge(g)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c81264050.filter0,tp,LOCATION_HAND,0,1,1,nil,e,tp,m)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		m:RemoveCard(tc)
		if tc.mat_filter then
			m=m:Filter(tc.mat_filter,nil)
		end
		local mat=nil
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=m:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=m:FilterSelect(tp,c81264050.filter1,1,1,nil,tp,m,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=m:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		local mat3=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		mat:Sub(mat3)
		Duel.ReleaseRitualMaterial(mat)
		Duel.SendtoGrave(mat3,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--묘지 회수
function c81264050.filter2(c)
	return c:IsFaceup() and c:GetAttack()==0
end
function c81264050.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c81264050.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
end
function c81264050.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsAbleToGraveAsCost,1,1,REASON_COST)
end
function c81264050.filter3(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc94) and c:IsType(TYPE_MONSTER)
end
function c81264050.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c81264050.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c81264050.filter3),tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81264050,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
