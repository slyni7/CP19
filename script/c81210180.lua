--MNF(비시아 큐리아) 가스코뉴 μ
--카드군 번호: 0xcb9 0xcff
local m=81210180
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
	
	--펜듈럼 존에서 발동
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x200)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	e3:SetHintTiming(0,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER)
	c:RegisterEffect(e3)
	
	--유발 효과
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.cn4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--펜듈럼 제약
function cm.plimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_MACHINE) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

--펜듈럼 존
function cm.nfil0(c)
	return c:IsSetCard(0xcb9) or c:IsSetCard(0xcff)
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and ( ph==PHASE_MAIN1 or ph==PHASE_MAIN2 )
	and Duel.IsExistingMatchingCard(cm.nfil0,tp,0x200,0,1,e:GetHandler())
end
function cm.tfil0(c)
	return c:IsFaceup() and c:IsReleasable() and c:IsType(TYPE_EFFECT)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(0x04) and chkc:IsControler(1-tp) and cm.tfil0(chkc)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingTarget(cm.tfil0,tp,0,0x04,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,cm.tfil0,tp,0,0x04,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	if tc:IsRelateToEffect(e) and Duel.Release(tc,REASON_EFFECT)~=0 then
		c:SetMaterial(nil)
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
	end
end

--특수 소환
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.spfil0(c,e,tp,ft)
	return (c:IsSetCard(0xcff) or (c:IsSetCard(0xcb9) and c:IsType(TYPE_RITUAL))) and c:IsType(0x1)
	and ( c:IsAbleToHand() or ft>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) )
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,0x04)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfil0,tp,0x01,0,1,nil,e,tp,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,nil)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,0x04)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x01,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP)
		and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
			tc:SetMaterial(nil)
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		else
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		Duel.Damage(tp,tc:GetLevel()*100,REASON_EFFECT)
	end
end
