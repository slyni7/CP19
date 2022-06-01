--永蝶の起床
--영원접의 기상
--카드군 번호: 0xc88
local m=81239040
local cm=_G["c"..m]
function cm.initial_effect(c)

	--공통 트리거
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x02)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e2)
end

--공통 트리거
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(0x10)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc88) and c:IsLevelAbove(5)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x01,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x01,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--특수 소환
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.tfil0(c)
	return c:IsFaceup() and c:IsReleasable() and c:IsRace(RACE_INSECT) and c:IsLevelAbove(2)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(0x04) and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingTarget(cm.tfil0,tp,0x04,0,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0x04,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsFaceup() and tc:IsLevelAbove(2)
	and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		Duel.Release(tc,REASON_EFFECT)
	end
	Duel.SpecialSummonComplete()
end
