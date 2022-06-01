--붉은 노을
--카드명 번호: 0xcbc
function c81230050.initial_effect(c)

	--토큰
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81230050,0))
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c81230050.co1)
	e1:SetTarget(c81230050.tg1)
	e1:SetOperation(c81230050.op1)
	c:RegisterEffect(e1)
	
	--공통 효과
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81230050,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetTarget(c81230050.tg2)
	e2:SetOperation(c81230050.op2)
	c:RegisterEffect(e2)
end

--토큰
function c81230050.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(81230050,tp,ACTIVITY_SPSUMMON)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(c81230050.lim)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81230050.lim(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_FIEND)
end
function c81230050.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81230070,0xcbc,0x5011,100,100,1,RACE_FIEND,ATTRIBUTE_FIRE)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c81230050.filter0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xcbc) and c:IsType(TYPE_MONSTER)
end
function c81230050.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,81230070,0xcbc,0x5011,100,100,1,RACE_FIEND,ATTRIBUTE_FIRE) then
		local token=Duel.CreateToken(tp,81230070)
		local og=Duel.GetMatchingGroup(c81230050.filter0,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0
		and Duel.GetCounter(e:GetHandlerPlayer(),1,0,0xcbc)>=3
		and og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81230050,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=og:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

--공통 효과
function c81230050.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xcbc) and c:IsCanAddCounter(0xcbc,1)
end
function c81230050.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp) and c81230030.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81230050.filter1,tp,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,94)
	Duel.SelectTarget(tp,c81230050.filter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0xcbc)
end
function c81230050.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0xcbc,1)
	end
end


