--USS(이글 유니온) 엘드릿지
--카드군 번호: 0xcb4
local m=81170210
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.mfil0,1,1)
	
	--파괴 내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x10)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	c:RegisterEffect(e2)
end

--링크 소환
function cm.mfil0(c)
	return c:IsLinkSetCard(0xcb4) and c:IsLinkType(TYPE_LINK) and c:GetLink()~=1
end

--파괴 내성
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(0x04,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xcb4))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(aux.indoval)
	Duel.RegisterEffect(e2,tp)
end

--특수 소환
function cm.nfil0(c)
	return c:IsFaceup() and c:IsSetCard(0xcb4) and c:IsType(TYPE_LINK)
end
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.nfil0,tp,0x04,0,1,nil)
end
function cm.tfil0(c,g)
	if #g==1 then
		return c:IsFaceup() and c:IsAbleToGrave() and c:IsSetCard(0xcb4) and not c:IsType(TYPE_LINK)
	else
		return c:IsFaceup() and c:IsAbleToGrave() and c:IsSetCard(0xcb4)
	end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.nfil0,tp,0x04,0,nil)
	if #g<=0 then
		return false
	end
	local zone=0
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	zone=bit.band(zone,0x1f)
	
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
		and Duel.GetLocationCount(tp,0x04,tp,LOCATION_REASON_TOFIELD,zone)>0
		and Duel.IsExistingMatchingCard(cm.tfil0,tp,0x04,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x04)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.nfil0,tp,0x04,0,nil)
	if #g<=0 then
		return false
	end
	local zone=0
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	zone=bit.band(zone,0x1f)
	if not c:IsRelateToEffect(e) or zone==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x04,0,1,1,nil,g)
	if #sg>0 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)
	end
end
