--NOSTALGIA@SPELL
local m=99000366
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99000355)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--nostalgia
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and ev>=2000 then
		Duel.RegisterFlagEffect(ep,99000366,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.thfilter(c)
	return (c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and aux.IsCodeListed(c,99000355) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99000366)~=0
end
function cm.cfilter1(c)
	return c:GetType()==TYPE_SPELL and c:IsSetCard(0xc13) and c:IsAbleToRemoveAsCost()
end
function cm.cfilter2(c)
	return c:GetType()==TYPE_SPELL+TYPE_QUICKPLAY and c:IsSetCard(0xc13) and c:IsAbleToRemoveAsCost()
end
function cm.cfilter3(c)
	return c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsSetCard(0xc13) and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_GRAVE,0,2,nil)
			and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_GRAVE,0,2,nil)
			and Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_GRAVE,0,2,2,nil)
	local g2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_GRAVE,0,2,2,nil)
	local g3=Duel.SelectMatchingCard(tp,cm.cfilter3,tp,LOCATION_GRAVE,0,2,2,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(99000366)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
	e:GetHandler():RegisterFlagEffect(99000366,RESET_PHASE+PHASE_END,0,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(99000366)==0 then return end
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	local chktoken=Duel.CreateToken(tp,ac)
	local ct=1
	while ct<=65535 do
		if (Auxiliary.AdditionalSetcardsList[ct] and chktoken:IsCode(table.unpack(Auxiliary.AdditionalSetcardsList[ct])))
			or chktoken:IsSetCard(ct) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_FORBIDDEN)
			e1:SetTargetRange(0x7f,0x7f)
			e1:SetTarget(cm.bantg)
			e1:SetLabel(ct)
			if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()<=PHASE_STANDBY then
				e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
			else
				e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			end
			Duel.RegisterEffect(e1,tp)
		end
		ct=ct+1
	end
end
function cm.bantg(e,c)
	local ct=e:GetLabel()
	return (Auxiliary.AdditionalSetcardsList[ct] and c:IsCode(table.unpack(Auxiliary.AdditionalSetcardsList[ct])))
		or c:IsSetCard(ct)
end