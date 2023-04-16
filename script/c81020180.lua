--초목의 사수
local m=81020180
local cm=_G["c"..m]
function cm.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,81020181)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	c:RegisterEffect(e2)
	
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(81020000)
	e4:SetRange(0x01+0x02+0x10+0x20)
	c:RegisterEffect(e4)
end

--activation
function cm.cfilter0(c,e,tp)
	return e:GetHandler():IsSetCard(0xca2) and c:IsHasEffect(81020200,tp) and c:IsAbleToRemoveAsCost()
end
function cm.cfilter1(c)
	return c:GetType()==0x2 and c:IsAbleToRemoveAsCost()
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.cfilter0,tp,0x04+0x10,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x10,0,1,nil)
	if chk==0 then
		return (b1 or b2) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0
	end
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(81020200,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter0,tp,0x04+0x10,0,1,1,nil,e,tp)
		local te=g:GetFirst():IsHasEffect(81020200,tp)
		if te then
			te:UseCountLimit(tp)
			Duel.Remove(g,POS_FACEUP,REASON_REPLACE)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x10,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(cm.lm1)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.lm1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xca2)
end
function cm.filter2(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(cm.filter2,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xca2,0x11,5,2100,0,RACE_PLANT,ATTRIBUTE_WIND)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.filter2,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() 
	and c:IsRelateToEffect(e) 
	and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xca2,0x11,5,2100,0,RACE_PLANT,ATTRIBUTE_WIND)
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
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ( ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE )
end
function cm.sstgfilter(c,tp)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0xca2)
	and c:IsHasEffect(81020000)
	and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),c:IsSetCard(),0x21,c:GetLevel(),c:GetAttack(),c:GetDefense(),c:GetRace(),c:GetAttribute())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sstgfilter,tp,LOCATION_REMOVED,0,1,nil,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end

function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetMatchingGroup(cm.sstgfilter,tp,LOCATION_REMOVED,0,nil,tp)
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
		tg:RegisterFlagEffect(m,RESET_EVENT+0x47c0000,0,1,fid)
		tg=sg:GetNext()
	end
	if Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 then
		sg:KeepAlive()
		Duel.BreakEffect()
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
	end
end
