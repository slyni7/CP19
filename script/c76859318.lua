--넥서스 트릴로지
function c76859318.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c76859318.con0)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetCountLimit(1,76859318+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c76859318.cost1)
	e1:SetTarget(c76859318.tar1)
	e1:SetOperation(c76859318.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(76859318,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCountLimit(1,76859319)
	e2:SetCondition(c76859318.con2)
	e2:SetCost(c76859318.cost2)
	e2:SetTarget(c76859318.tg2)
	e2:SetOperation(c76859318.op2)
	c:RegisterEffect(e2)
end
function c76859318.nfil0(c)
	return c:IsFacedown() or not c:IsSetCard(0x2c5)
end
function c76859318.con0(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsExistingMatchingCard(c76859318.nfil0,tp,LOCATION_MZONE,0,1,nil)
		and Duel.CheckLPCost(tp,1600)
end
function c76859318.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return true
	end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.PayLPCost(tp,1600)
	end
end
function c76859318.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>2
			and Duel.IsPlayerCanSpecialSummonMonster(tp,76859319,0x2c5,TYPES_TOKEN+TYPE_TUNER,
				1600,800,4,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,tp,0)
end
function c76859318.ofil1(c,mg)
	return c:IsSetCard(0x2c5) and c:IsSynchroSummonable(nil,mg)
end
function c76859318.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)<3 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,76859319,0x2c5,TYPES_TOKEN+TYPE_TUNER,
			1600,800,4,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_DEFENSE,1-tp) then
		return
	end
	local mg=Group.CreateGroup()
	for i=0,2 do
		local token=Duel.CreateToken(tp,76859319)
		mg:AddCard(token)
		if Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetAbsoluteRange(tp,1,0)
			e1:SetValue(c76859318.oval11)
			c:RegisterEffect(e1,true)
		end
	end
	Duel.SpecialSummonComplete()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local mc=mg:GetFirst()
	while mc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		mc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_END)
		e2:SetLabelObject(e1)
		e2:SetOperation(c76859318.oop12)
		Duel.RegisterEffect(e2,tp)
		mc=mg:GetNext()
	end
	local sg=Duel.SelectMatchingCard(tp,c76859318.ofil1,tp,LOCATION_EXTRA,0,0,1,nil,mg)
	if #sg>0 then
		Duel.BreakEffect()
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function c76859318.oop12(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function c76859318.oval11(e,re,tp)
	return re:IsActiveType(TYPE_SPELL)
end
function c76859318.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function c76859318.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
	end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c76859318.tfilter21(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x2c5) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c76859318.tfilter22(c)
	return c:IsSetCard(0x2c5) and c:IsType(TYPE_TRAP) and c:IsSSetable() and not c:IsCode(76859318)
end
function c76859318.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c76859318.tfilter21,tp,LOCATION_DECK,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c76859318.tfilter22,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c76859318.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
		return
	end
	local g1=Duel.GetMatchingGroup(c76859318.tfilter21,tp,LOCATION_DECK,0,nil,e,tp)
	local g2=Duel.GetMatchingGroup(c76859318.tfilter22,tp,LOCATION_DECK,0,nil)
	if g1:GetCount()<1 or g2:GetCount()<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc2=g2:Select(tp,1,1,nil)
	Duel.SpecialSummon(tc1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	Duel.SSet(tp,tc2:GetFirst())
end