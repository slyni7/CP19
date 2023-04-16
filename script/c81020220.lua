--초목 고요
--카드군 번호: 0xca2
local m=81020220
local cm=_G["c"..m]
function cm.initial_effect(c)

	
	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.sumfil)
	
	--지속 효과
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(0x04)
	e2:SetValue(cm.va2)
	c:RegisterEffect(e2)
	
	--소환 유발
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(81020000)
	e4:SetRange(0x01+0x02+0x10+0x20)
	c:RegisterEffect(e4)
end

--특수 소환
function cm.sumfil(c)
	return c:IsSetCard(0xca2)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.co1tg1)
	Duel.RegisterEffect(e1,tp)
end
function cm.co1tg1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xca2)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xca2,0x21,1,400,1700,RACE_PLANT,ATTRIBUTE_WIND)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0xca2,0x21,1,400,1700,RACE_PLANT,ATTRIBUTE_WIND) then
		c:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		c:RegisterEffect(e1,true)
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	end
end

--지속 효과
function cm.va2(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--리쿠르트
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.tfilter0(c,tp)
	return Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),c:IsSetCard(),0x21,c:GetLevel(),c:GetAttack(),c:GetDefense(),c:GetRace(),c:GetAttribute()) 
	and c:IsHasEffect(81020000)
	and c:GetType()~=0x10002
end
function cm.nfilter0(c)
	return c:IsFaceup() and c:IsCode(81020080)
end
function cm.tfilter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xca2) and c:IsType(0x2)
	and c:GetType()~=0x10002
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(cm.tfilter0,tp,0x01,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.nfilter0,tp,0x0c,0x0c,1,nil)
		and Duel.GetLocationCount(tp,0x04)>0
	local b2=Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x01,0,1,nil)
	if chk==0 then
		return b1 or b2
	end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(cm.tfilter0,tp,0x01,0,1,nil,tp)
		and Duel.IsExistingMatchingCard(cm.nfilter0,tp,0x0c,0x0c,1,nil)
		and Duel.GetLocationCount(tp,0x04)>0
	local b2=Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x01,0,1,nil)
	
	if b1 and (not b2 or Duel.SelectOption(tp,1190,1152)==1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.tfilter0,tp,0x01,0,1,1,nil,tp)
		local tg=g:GetFirst()
		local fid=e:GetHandler():GetFieldID()
		while tg do
			local e0=Effect.CreateEffect(tg)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetCode(EFFECT_CHANGE_TYPE)
			e0:SetValue(TYPE_EFFECT+TYPE_MONSTER)
			e0:SetReset(RESET_EVENT+0x47c0000)
			tg:RegisterEffect(e0,true)
			tg:RegisterFlagEffect(m,RESET_EVENT+0x47c0000,0,1,fid)
			tg=g:GetNext()
		end
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		g:KeepAlive()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,0x01,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function cm.op3tg1(e,c,sump,sumtype,sumpos,targetp,se)
	return se and se:GetHandler():IsCode(m) and c:GetOriginalCode()==e:GetLabel()
end
function cm.op3tg2(e,c,tp,re)
	return c:IsCode(e:GetLabel()) and re and re:GetHandler():IsCode(m)
end