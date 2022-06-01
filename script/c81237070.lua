--귀도의 시련(귀부, 귀정)
--카드군 번호: 0xc8c
local m=81237070
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--리쿠르트
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.cn2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
end

--효과를 발동할 수 없으며, 무효화된다
function cm.filter1(c)
	return c:IsFaceup() and c:IsCode(81237000)
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter1,tp,0x0c+0x10,0,1,nil)
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsType(TYPE_DUAL)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x02+0x10,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x10)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.filter2(c)
	return c:IsAbleToRemove() and c:IsType(0x1) and c:IsType(TYPE_EFFECT)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.filter1,tp,0x0c+0x10,0,1,nil) then
		return
	end
	if Duel.IsChainDisablable(0) then
		local g1=Duel.GetMatchingGroup(cm.filter2,tp,0,0x02+0x0c+0x10,nil)
		if #g1>2 and Duel.SelectYesNo(1-tp,aux.Stringid(m,3)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local sg1=g1:Select(1-tp,3,3,nil)
			Duel.ConfirmCards(tp,sg1)
			Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	local ft=Duel.GetLocationCount(tp,0x04)
	local g2=Duel.GetMatchingGroup(cm.spfil0,tp,0x02+0x10,0,nil,e,tp)
	if ft<=0 or #g2==0 then
		return
	end
	if Duel.IsPlayerAffectedByEffect(tp,59822133,14941411) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=g2:Select(tp,ft,ft,nil)
	local tc=sg2:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:EnableDualState()
		tc=sg2:GetNext()
	end
	Duel.SpecialSummonComplete()
end

--리쿠르트
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated()
	and (re:GetHandler():IsSetCard(0xc8c) or re:GetHandler():IsCode(81237000))
end
function cm.spfil1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc8c) and c:IsType(TYPE_DUAL)
	and Duel.IsExistingMatchingCard(cm.spfil2,tp,0x01,0,1,nil,e,tp,c:GetCode())
end
function cm.spfil2(c,e,tp,code)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc8c) and c:IsType(TYPE_DUAL)
	and not c:IsCode(code)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,0x04)>1
		and Duel.IsExistingMatchingCard(cm.spfil1,tp,0x01,0,1,nil,e,tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133,14941411)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0x01)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133,14941411) and Duel.GetLocationCount(tp,0x04)>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,cm.spfil1,tp,0x01,0,1,1,nil,e,tp)
		if #g1<=0 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g2=Duel.SelectMatchingCard(tp,cm.spfil2,tp,0x01,0,1,1,nil,e,tp,g1:GetFirst():GetCode())
		g1:Merge(g2)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
