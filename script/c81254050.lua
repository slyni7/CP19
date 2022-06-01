--천공 바다(선령)
--카드군 번호: 0xc9f
local m=81254050
local cm=_G["c"..m]
function cm.initial_effect(c)

	aux.AddCodeList(c,81254000)

	--발동시
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.co1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--의식 소환
	local e2=aux.AddRitualProcGreater2Code(c,81254030,nil,nil,cm.mfil0)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.cn2)
	e2:SetCost(cm.co2)
end

--서치
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.cva1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.cva1(e,re,tp)
	return re:IsActiveType(0x1) and not re:GetHandler():IsSetCard(0xc9f)
end
function cm.ofil0(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc9f) and c:IsType(0x1)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	local g=Duel.GetMatchingGroup(cm.ofil0,tp,0x01+0x10,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

--의식 소환
function cm.cn2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToGraveAsCost()
	end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.mfil0(c)
	return c:IsSetCard(0xc9f)
end
