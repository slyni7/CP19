--개풍쾌청화염각
--카드군 번호: 0xcae
local m=81110220
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableCounterPermit(0xcae)
	c:SetCounterLimit(0xcae,5)
	
	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(0x100)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	
	--특수 소환
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(0x100)
	e3:SetCountLimit(2)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	
	--카운터
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetRange(0x100)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--서치
function cm.tfilter1(c)
	return c:IsSSetable(ignore) and c:IsType(0x2+0x4)and c:IsSetCard(0xcae)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x08)>0
		and Duel.IsExistingMatchingCard(cm.tfilter1,tp,0x01,0,1,nil)
	end
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(tp,0x08)<=0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,cm.tfilter1,tp,0x01,0,1,1,nil):GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end

--특수 소환
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsCanRemoveCounter(tp,1,1,0x1011,2,REASON_COST)
	end
	Duel.RemoveCounter(tp,1,1,0x1011,2,REASON_COST)
end
function cm.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xcae)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,0x02+0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x10)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter1),tp,0x02+0x10,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--카운터를 놓는다
function cm.ofilter1(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousSetCard(0xcae) and c:IsLocation(0x10)
	and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(cm.ofilter1,nil,tp)
	if ct>0 then
		e:GetHandler():AddCounter(0x1011,ct)
	end
end
