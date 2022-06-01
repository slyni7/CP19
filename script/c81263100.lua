--궤룡 아트로피네
--카드군 번호: 0xc95
function c81263100.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,aux.FilterBoolFunction(c81263100.mat),aux.FilterBoolFunction(Card.IsCode,81263060),2,5,nil)
	
	--유발 즉시
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81263100,2))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,81263100)
	e1:SetCondition(c81263100.cn1)
	e1:SetCost(c81263100.co1)
	e1:SetTarget(c81263100.tg1)
	e1:SetOperation(c81263100.op1)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(81263100,3))
	e3:SetCost(c81263100.co3)
	e3:SetTarget(c81263100.tg3)
	e3:SetOperation(c81263100.op3)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(81263100,4))
	e4:SetCost(c81263100.co4)
	e4:SetTarget(c81263100.tg4)
	e4:SetOperation(c81263100.op4)
	c:RegisterEffect(e4)
	
	--유발
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,81263101)
	e2:SetCondition(c81263100.cn2)
	e2:SetTarget(c81263100.tg2)
	e2:SetOperation(c81263100.op2)
	c:RegisterEffect(e2)
	
	--내성
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetRange(0x04)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
end

--모듈 소환
function c81263100.mat(c)
	return c:IsType(TYPE_MODULE) and c:IsSetCard(0xc95) and not c:IsAttribute(ATTRIBUTE_WIND)
end

--유발 즉시 효과
function c81263100.cn1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c81263100.cfil0(c)
	return c:IsAbleToRemoveAsCost() and ( c:IsRace(RACE_WYRM) or c:GetType()&0x02+TYPE_EQUIP==0x02+TYPE_EQUIP )
end
--묘지
function c81263100.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81263100.cfil0,tp,0x10,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81263100.cfil0,tp,0x10,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81263100.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0x10,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x10)
end
function c81263100.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x10,1,2,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		local mg=Duel.GetOperatedGroup()
		if mg:IsExists(Card.IsLocation,1,nil,0x01) then
			Duel.ShuffleDeck(1-tp)
		end
	end
end
--필드
function c81263100.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81263100.cfil0,tp,0x10,0,2,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81263100.cfil0,tp,0x10,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81263100.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0x0c,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x0c)
end
function c81263100.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,0x0c,1,2,nil)
	if #g>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
		local mg=Duel.GetOperatedGroup()
		if mg:IsExists(Card.IsLocation,1,nil,0x01) then
			Duel.ShuffleDeck(1-tp)
		end
	end
end
--패
function c81263100.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81263100.cfil0,tp,0x10,0,3,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81263100.cfil0,tp,0x10,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c81263100.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,0x02,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,0x02)
end
function c81263100.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.GetFieldGroup(tp,0,0x02)
	if #cg>0 then
		Duel.ConfirmCards(tp,cg)
		local tg=Duel.GetMatchingGroup(aux.TRUE,tp,0,0x02,nil)
		if #tg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg2=tg:Select(tp,1,2,nil)
			Duel.SendtoDeck(sg2,nil,2,REASON_EFFECT)
		end
		Duel.ShuffleHand(1-tp)
	end
end

--유발
function c81263100.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_MODULE) and c:GetReasonPlayer()==1-tp
end
function c81263100.spfil0(c,e,tp)
	return c:IsLevelBelow(7) and c:IsType(TYPE_MODULE) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP)
end
function c81263100.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c81263100.spfil0,tp,0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x10)
	Duel.SetChainLimit(aux.FALSE)
end
function c81263100.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c81263100.spfil0,tp,0x10,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
