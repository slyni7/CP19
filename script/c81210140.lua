--MNF(비시아 큐리아) 장 바르 - 라스트 블라스트
--카드군 번호: 0xcb9
local m=81210140
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)

	--펜듈럼 제약
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cm.plimit)
	c:RegisterEffect(e2)
	
	--리쿠르트
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--자체 의식소환
	local e4=aux.AddRitualProcGreater2(c,cm.tfil0,nil,nil,cm.mfil0)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(0x02)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.cn4)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)

	--연속 공격
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	
	--퍼미션
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(cm.cn6)
	e6:SetCost(cm.co6)
	e6:SetTarget(cm.tg6)
	e6:SetOperation(cm.op6)
	c:RegisterEffect(e6)
end

--펜듈럼 제약
function cm.plimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--리쿠르트
function cm.nfil0(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and bit.band(c:GetPreviousTypeOnField(),TYPE_PENDULUM)~=0
	and c:IsPreviousLocation(0x0c) and c:GetPreviousControler()==tp
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfil0,1,nil,tp)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_PENDULUM) 
	and c:IsSetCard(0xcb9)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x01+0x02,0,1,nil,e,tp)
		and e:GetHandler():IsAbleToHand()
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x02)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	if not c:IsRelateToEffect(e) or c:IsFacedown() then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x01+0x02,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoHand(c,nil,REASON_EFFECT+REASON_RETURN)
	end
end

--자체 의식소환
function cm.tfil0(c,e,tp,chk)
	return c:IsSetCard(0xcb9) and (not chk or c:IsType(TYPE_RITUAL))
end
function cm.mfil0(c,e,tp,chk)
	return not chk or not c:IsType(TYPE_RITUAL)
end
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end

--퍼미션
function cm.cn6(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(0x2+0x4) and Duel.IsChainNegatable(ev)
end
function cm.cfil0(c)
	return c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.co6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x40,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x40,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(e) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x0c+0x10)
	end
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then
		return
	end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,0x0c+0x10,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
