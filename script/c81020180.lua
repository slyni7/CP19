--초목의 사수
function c81020180.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81020180,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81020180)
	e1:SetCost(c81020180.co1)
	e1:SetTarget(c81020180.tg1)
	e1:SetOperation(c81020180.op1)
	c:RegisterEffect(e1)
	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81020180,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81020181)
	e2:SetCondition(c81020180.cn2)
	e2:SetTarget(c81020180.tg2)
	e2:SetOperation(c81020180.op2)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	c:RegisterEffect(e2)
end

--activation
function c81020180.filter1(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL) 
	and not ( c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_CONTINUOUS) or c:IsType(TYPE_EQUIP) 
	or c:IsType(TYPE_FIELD) or c:IsType(TYPE_RITUAL) )	
end
function c81020180.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81020180.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.GetCustomActivityCount(81020180,tp,ACTIVITY_SPSUMMON)==0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c81020180.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(c81020180.lm1)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81020180.lm1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xca2)
end
function c81020180.filter2(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c81020180.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c81020180.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81020180.filter2,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,81020180,0xca2,0x11,5,2100,0,RACE_PLANT,ATTRIBUTE_WIND)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c81020180.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c81020180.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() 
	and c:IsRelateToEffect(e) 
	and Duel.IsPlayerCanSpecialSummonMonster(tp,81020180,0xca2,0x11,5,2100,0,RACE_PLANT,ATTRIBUTE_WIND)
	and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.BreakEffect()
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	end
end

--act in hand
function c81020180.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ( ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE )
end
function c81020180.sstgfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0xca2)
	and ( c:IsCode(81020000) or c:IsCode(81020010) or c:IsCode(81020020) or c:IsCode(81020030) or c:IsCode(81020060) or c:IsCode(81020180) or c:IsCode(81020180)  )
	and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0xca2,0x21,0,0,0,RACE_PLANT,ATTRIBUTE_WIND)
end
function c81020180.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c81020180.sstgfilter,tp,LOCATION_REMOVED,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end

function c81020180.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(c81020180.sstgfilter,tp,LOCATION_REMOVED,0,nil,tp)
	if g:GetCount()<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	local tg=sg:GetFirst()
	local fid=e:GetHandler():GetFieldID()
	while tg do
		local e1=Effect.CreateEffect(tg)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tg:RegisterEffect(e1,true)
		tg:RegisterFlagEffect(81020180,RESET_EVENT+0x47c0000,0,1,fid)
		tg=sg:GetNext()
	end
	if Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 then
		sg:KeepAlive()
		Duel.BreakEffect()
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
