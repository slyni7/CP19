--SAMSARA@SPELL
local m=99000365
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99000355)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.con1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
	--grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCondition(cm.grcon)
	e4:SetTarget(cm.grtg)
	e4:SetOperation(cm.grop)
	c:RegisterEffect(e4)
	--cannot be material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(cm.limcon)
	e5:SetValue(cm.fuslimit)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e8)
	--act limit
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetRange(LOCATION_GRAVE)
	e9:SetTargetRange(0,1)
	e9:SetCondition(cm.aclimcon)
	e9:SetValue(cm.aclimit)
	c:RegisterEffect(e9)
end
--return the global index of the zone in (p,loc,seq)
function cm.SequenceToGlobal(p,loc,seq)
	if p~=0 and p~=1 then
		return 0
	end
	if loc==LOCATION_MZONE then
		if seq<=6 then
			return 0x1<<(16*p+seq)
		else
			return 0
		end
	elseif loc == LOCATION_SZONE then
		if seq<=4 then
			return 0x10<<(16*p+seq)
		else
			return 0
		end
	else
		return 0
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return not (t>s)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return t>s
end
function cm.spell_filter(c)
	return c:IsSetCard(0xc13) and c:IsType(TYPE_SPELL) and not c:IsPublic()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spell_filter,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()==0 then return end
	local first=g:GetFirst()
	local tc=g:GetNext()
	while tc do
		if tc:GetSequence()>first:GetSequence() then first=tc end
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,cm.spell_filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g2)
	Duel.ShuffleHand(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.Remove(first,POS_FACEUP,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		if tc:IsType(TYPE_LINK) then
			Duel.BreakEffect()
			local val=0
			local og=Duel.GetOperatedGroup()
			local tc=og:GetFirst()
			while tc do
				val=val|cm.SequenceToGlobal(tc:GetPreviousControler(),LOCATION_MZONE,tc:GetPreviousSequence())
				tc=og:GetNext()
			end
			local flag1=bit.band(tc:GetLinkedZone(tp)-0x600040,0x1f)
			local flag2=bit.band(tc:GetLinkedZone(1-tp)-0x600040,0x1f)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetValue(val)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_REPEAT)
			e2:SetCode(EFFECT_DISABLE_FIELD)
			e2:SetLabel(flag1+flag2*0x10000)
			e2:SetOperation(cm.disop)
			e2:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function cm.disop(e,tp)
	return e:GetLabel()
end
function cm.grcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_GRAVE,0,2,nil) end
end
function cm.grop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg1=g:Select(tp,1,1,nil)
	Duel.HintSelection(tg1)
	Duel.MoveSequence(tg1:GetFirst(),0)
	g:RemoveCard(tg1:GetFirst())
	if g:GetCount()==0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_GRAVE,0,nil)
		g:RemoveCard(tg1:GetFirst())
		repeat
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg2=g:Select(tp,1,1,nil)
			Duel.HintSelection(tg2)
			Duel.MoveSequence(tg2:GetFirst(),0)
			g:RemoveCard(tg2:GetFirst())
		until g:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(m,2))
	end
end
function cm.limcon(e)
	local tp=e:GetHandler():GetControler()
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	if e:GetHandler()==tc then
		return true
	else
		return false
	end
end
function cm.fuslimit(e,c,sumtype)
	return sumtype&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function cm.aclimcon(e)
	local tp=e:GetHandler():GetControler()
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	if e:GetHandler()==tc and Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil,99000355) then
		return true
	else
		return false
	end
end
function cm.aclimit(e,re,tp)
	local tc=Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
	if tc then
		local lim=tc:GetCode()
		return not re:GetHandler():IsCode(lim)
	end
end