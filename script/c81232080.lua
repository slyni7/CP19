--기연극의 커튼콜
--카드군 번호: 0x2cba
local m=81232080
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:SetUniqueOnField(1,0,m)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--리쿠르트
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x08)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	c:RegisterEffect(e2)
	
	--묘지 회수
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(0x10)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--리쿠르트
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.cfilter1(c,e,tp,ft)
	local ft=Duel.GetLocationCount(tp,0x04)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0x1cba)
	and ( c:IsLocation(0x02) or (c:IsFaceup() and c:IsLocation(0x04)) or (c:IsFacedown() and c:IsLocation(0x08)) )
	and Duel.IsExistingMatchingCard(cm.spfilter1,tp,0x01+0x10,0,1,nil,e,tp,ft,c:GetCode())
end
function cm.spfilter1(c,e,tp,ft,code)
	return ((ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) or c:IsSSetable())
	and c:IsSetCard(0x1cba) and c:IsType(0x1) and not c:IsCode(code)
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter1,tp,0x02+0x0c,0,1,nil,e,tp,ft)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,0x02+0x0c,0,1,1,nil,e,tp,ft)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetValue(g:GetFirst():GetCode())
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x01+0x10)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,0x04)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter1),tp,0x01+0x10,0,1,1,nil,e,tp,ft,e:GetValue())
	if #g>0 then
		local tc=g:GetFirst()
		if tc:IsSSetable() and (ft<=0 or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
			Duel.SSet(tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

--마법 & 함정 존에 놓는다
function cm.nfilter1(c,tp)
	return c:IsControler(tp) and c:IsFaceup() and c:IsCode(81232000)
end
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.nfilter1,1,nil,tp)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsSSetable()
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
