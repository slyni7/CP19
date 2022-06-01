--귀정 역병 수의
--카드군 번호: 0xc8c
local m=81237030
local cm=_G["c"..m]
function cm.initial_effect(c)

	aux.EnableDualAttribute(c)
	
	--공통 효과
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetRange(0x04)
	e1:SetCondition(aux.IsDualState)
	e1:SetValue(cm.va1)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x02)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--리쿠르트
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(0x04)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--전투 데미지 반사
function cm.va1(e,c)
	if e:GetHandler():GetFlagEffect(m)~=0 then
		Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		e:GetHandler():ResetFlagEffect(m)
		return true
	elseif Duel.GetFlagEffect(e:GetHandlerPlayer(),m)==0 then
		e:GetHandler():RegisterFlagEffect(m,0,0,1)
		return true
	else
		return false
	end
end

--서치

function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsDiscardable() and c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc8c) and c:IsType(0x2+0x4)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(81237000)
end
function cm.filter1(c)
	return c:IsAbleToHand() and c:IsType(TYPE_DUAL)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil)
	if #g>0 and	Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and Duel.ConfirmCards(1-tp,g) then
		local mg=Duel.IsExistingMatchingCard(cm.filter,tp,0x0c+0x10,0,1,nil)
		local og=Duel.GetMatchingGroup(cm.filter1,tp,0x10,0,nil)
		if mg and #og>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=og:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

--리쿠르트
function cm.nfil0(c,tp)
	return (c:IsReason(REASON_BATTLE) or c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT))
	and c:IsPreviousLocation(0x04) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousSetCard(0xc8c) and c:IsType(0x1)
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return aux.IsDualState(e) and eg:IsExists(cm.nfil0,1,e:GetHandler(),tp)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and c:IsSetCard(0xc8c) and c:IsType(TYPE_DUAL)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x01,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x01,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		tc:EnableDualState()
	end
	Duel.SpecialSummonComplete()
end
