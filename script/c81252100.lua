--극절의 프리즈스타
--카드군 번호: 0xc81
local m=81252100
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	c:RegisterEffect(e1)
	local e5=e1:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetCode(EVENT_TO_HAND)
	c:RegisterEffect(e6)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.chkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_TO_HAND)
		ge2:SetOperation(cm.chkop2)
		Duel.RegisterEffect(ge2,0)
	end
	--패에서 발동
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.cn3)
	c:RegisterEffect(e3)
	--묘지 효과
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(0x10)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.co4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end

--한데스
function cm.chkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsPreviousLocation(0x01) then return end
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),m,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function cm.chkop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsPreviousLocation(0x01) or tc:IsReason(REASON_DRAW) then return end
	while tc do
		Duel.RegisterFlagEffect(tc:GetControler(),m,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,m)>0
end
function cm.tfil0(c)
	return c:IsAbleToRemove() and c:IsSetCard(0xc81)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,0,0x02)>0
		and Duel.IsExistingMatchingCard(cm.tfil0,tp,0x02,0,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0x02)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x02)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x02,0,nil)
	if #g<=0 then return end
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroup(tp,0,0x02)
	local dis=1
	if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(0x08) then dis=dis+1 end
	if #ct>0 then
		Duel.ConfirmCards(tp,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=ct:Select(tp,1,dis,nil)
		if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then
			Duel.ShuffleHand(1-tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg2=g:Select(tp,1,1,nil)
			Duel.Remove(sg2,POS_FACEUP,REASON_EFFECT)
		end
	end
end

--패에서 발동
function cm.nfil0(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function cm.nfil1(c)
	return c:IsFaceup() and c:IsSetCard(0xc81) and c:IsType(TYPE_RITUAL)
end
function cm.cn3(e)
	local tp=e:GetHandler():GetControler()
	local g=Duel.GetMatchingGroup(cm.nfil0,tp,0x04,0,nil)
	return #g==0 or Duel.IsExistingMatchingCard(cm.nfil1,tp,0x04,0,1,nil)
end


--묘지 효과
function cm.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,0x02,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,0x02,0,1,1,nil)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.spfil0(c,e,tp,ft)
	return c:IsSetCard(0xc81) and c:IsType(0x1)
	and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,0x04)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.spfil0,tp,0x01,0,1,nil,e,tp,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,0x01)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0x01)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,0x04)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x01,0,1,1,nil,e,tp,ft)
	if #g>0 then
		local tc=g:GetFirst()
		if tc then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and ft>0
			and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
