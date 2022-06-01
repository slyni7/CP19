--귀정 꽃무릇
--카드군 번호: 0xc8c
local m=81237020
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
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x04)
	e2:SetCountLimit(1,m)
	e2:SetCondition(aux.IsDualState)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--서치
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
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
function cm.cfil0(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xc8c) and c:IsType(0x2+0x4)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfil0,tp,0x01+0x02,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfil0,tp,0x01+0x02,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_DUAL)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x02+0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x10)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x02+0x10,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--서치
function cm.tfil0(c,tp)
	return c:IsAbleToHand() and c:IsSetCard(0xc8c) and (not c:IsCode(m))
	and Duel.IsExistingMatchingCard(cm.filter1,tp,0x01,0,1,nil,c:GetCode())
end
function cm.filter1(c,code)
	return c:IsAbleToGrave() and c:IsType(TYPE_DUAL) and not c:IsCode(code)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,0x01)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil,tp)
	if #g1>0 and Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 and g1:GetFirst():IsLocation(0x02) then
		Duel.ConfirmCards(1-tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g2=Duel.SelectMatchingCard(tp,cm.filter1,tp,0x01,0,1,1,nil,g1:GetFirst():GetCode())
		if #g2>0 then
			Duel.SendtoGrave(g2,REASON_EFFECT)
		end
	end
end
