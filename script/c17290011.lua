--파이널 엘리시아
function c17290011.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,17290011+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c17290011.tg1)
	e1:SetOperation(c17290011.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17290011,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e2:SetCondition(c17290011.con2)
	e2:SetTarget(c17290011.tg2)
	e2:SetOperation(c17290011.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMONABLE_CARD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(c17290011.tg2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_LIMIT_SET_PROC)
	e4:SetCondition(c17290011.con4)
	e4:SetTarget(c17290011.tg2)
	c:RegisterEffect(e4)
end
function c17290011.con4(e,c)
	if not c then
		return true
	end
	return false
end
function c17290011.tfilter11(c,e,tp,m)
	if not c:IsSetCard(0x8) or not c:IsSetCard(0x2c3) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then
		return false
	end
	local mg=m:Clone()
	mg:RemoveCard(c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		return mg:CheckWithSumGreater(c17290011.tfunction1,c:GetLevel(),c)
	else
		return mg:IsExists(c17290011.tfilter14,1,nil,tp,mg,c)
	end
end
function c17290011.tfilter14(c,tp,m,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return m:CheckWithSumGreater(c17290011.tfunction1,rc:GetLevel(),rc)
	else
		return false
	end
end
function c17290011.tfunction1(c,rc)
	if c:IsType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetRitualLevel(rc)
	end
end
function c17290011.tfilter12(c)
	return c:IsFaceup() and c:IsSetCard(0x8) and c:IsSetCard(0x2c3) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c17290011.tfilter13(c)
	return c:IsFaceup() and c:IsSetCard(0x2c3) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand() and not c:IsCode(17290011)
end
function c17290011.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(c17290011.tfilter12,tp,LOCATION_REMOVED,0,1,nil)
			and Duel.IsExistingTarget(c17290011.tfilter13,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c17290011.tfilter12,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c17290011.tfilter13,tp,LOCATION_REMOVED,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c17290011.ofilter1(c,e)
	return c:IsReleasable() and not c:IsImmuneToEffect(e)
end
function c17290011.op1(e,tp,eg,ep,ev,re,r,rp)
	local flag=nil
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT) then
		flag=true
		Duel.ConfirmCards(1-tp,sg)
	end
	local m=Duel.GetRitualMaterial(tp)
	local mg=Duel.GetMatchingGroup(c17290011.ofilter1,tp,LOCATION_MZONE,0,nil,e)
	m:Merge(mg)
	if not flag or not Duel.IsExistingMatchingCard(c17290011.tfilter11,tp,LOCATION_HAND,0,1,nil,e,tp,m)
		or not Duel.SelectYesNo(tp,aux.Stringid(17290011,0)) then
		return
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c17290011.tfilter11,tp,LOCATION_HAND,0,1,1,nil,e,tp,m)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		m:RemoveCard(tc)
		if tc.mat_filter then
			m=m:Filter(tc.mat_filter,nil)
		end
		local mat=nil
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=m:SelectWithSumGreater(tp,c17290011.tfunction1,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=m:FilterSelect(tp,c17290011.tfilter14,1,1,nil,tp,m,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=m:SelectWithSumGreater(tp,c17290011.tfunction1,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c17290011.con2(e,c)
	if c==nil then
		return e:GetHandler():IsAbleToRemove()
	end
	local tp=c:GetControler()
	local m=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and m:CheckWithSumGreater(c17290011.tfunction1,c:GetLevel(),c)
end
function c17290011.tg2(e,c)
	if type(c)=="Card" then
		return c:IsSetCard(0x2c3)
	else
		return true
	end
end
function c17290011.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local m=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
	if c.mat_filter then
		m=m:Filter(c.mat_filter,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mat=m:SelectWithSumGreater(tp,c17290011.tfunction1,c:GetLevel(),c)
	mat:AddCard(e:GetHandler())
	c:SetMaterial(mat)
	Duel.Remove(mat,POS_FACEUP,REASON_COST+REASON_RITUAL+REASON_MATERIAL+REASON_SUMMON)
end