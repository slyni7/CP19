--비현 - 배면의 사염
--카드군 번호: 0x1c80
local m=81253120
local cm=_G["c"..m]
function cm.initial_effect(c)

	--묘지로 보낸다
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(0x04)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.cn4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	
	--특수 소환
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(0x02)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.cn5)
	e5:SetCost(cm.co5)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	e5:SetHintTiming(0,TIMING_MAIN_END)
	c:RegisterEffect(e5)
	
	--소환 유발
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetCountLimit(1,m+1)
	e6:SetTarget(cm.tg6)
	e6:SetOperation(cm.op6)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
end

--묘지로 보낸다
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.cn4(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsFaceup() and e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	end
end

--특수 소환
function cm.cn5(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.cfil0(c)
	return c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function cm.co5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x02,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x02,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x10)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,1-tp) and c:IsSetCard(0x1c80) and c:IsLevelBelow(7)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,0x04)<=0 then
		return
	end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)~=0 then
		local g=Duel.GetMatchingGroup(cm.spfil0,tp,0x02+0x10,0,nil,e,tp)
		if #g>0 and Duel.GetLocationCount(1-tp,0x04)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc then
				Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
			end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(81253000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(10)
			tc:RegisterEffect(e2)
		end
	end
end

--유발 효과
function cm.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0x1c80)
end
function cm.check_trigger(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsCode(81253000)
end
function cm.tg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x01,0,nil)
		return g:GetClassCount(Card.GetCode)>=2
		and (Duel.IsPlayerCanDraw(tp,1) or Duel.IsExistingMatchingCard(cm.check_trigger,tp,0x10,0,1,nil))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
	if Duel.IsExistingMatchingCard(cm.check_trigger,tp,0x10,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x10)
	end
end
function cm.op6(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x01,0,nil)
	if g:GetClassCount(Card.GetCode)<2 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
	if Duel.SendtoGrave(sg,REASON_EFFECT)==2 then
		local tg=Duel.GetMatchingGroup(cm.check_trigger,tp,0x10,0,nil)
		if #tg>0 and (not Duel.IsPlayerCanDraw(tp,1) or not Duel.IsPlayerAffectedByEffect(tp,47355498))
		and	Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=tg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
		else
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
