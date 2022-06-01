--그림자무리의 침묵
--카드군 번호: 0xcb3
--refined 20.05.12.
local m=81160080
local cm=_G["c"..m]
function cm.initial_effect(c)

	--발동
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(cm.cn0)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMING_MAIN_END)
	c:RegisterEffect(e1)
	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(0x08)
	e2:SetCondition(cm.cn1)
	e2:SetCost(cm.co2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op1)
	e2:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMING_MAIN_END)
	c:RegisterEffect(e2)
	
	--기동
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNTION)
	e3:SetRange(0x10)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--프리체인
function cm.cn0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.spfil0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xcb3)
end
function cm.tfil0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcb3) and c:IsType(0x1)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	local b1=Duel.GetLocationCount(tp,0x04)>0 and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x02+0x10,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	local op=2
	e:SetCategory(0)
	if Duel.GetFlagEffect(tp,m)==0 and (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(m,1))
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
		end
		if op==0 then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x10)
		else
			e:SetCategory(CATEGORY_TOGRAVE)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
		end
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	e:SetLabel(op)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==2 or not e:GetHandler():IsRelateToEffect(e) then
		return
	end
	if e:GetLabel()==0 then
		if Duel.GetLocationCount(tp,0x04)<=0 then
			return
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfil0),tp,0x02+0x10,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tfil0,tp,0x01,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end

--instant
function cm.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,m)==0
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetLocationCount(tp,0x04)>0 and Duel.IsExistingMatchingCard(cm.spfil0,tp,0x02,0,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	if chk==0 then
		return b1 or b2
	end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02)
	else
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01)
	end
end

--기동
function cm.tfil1(c)
	return c:IsAbleToHand() and c:IsCode(81160000)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.tfil1,tp,0x01,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tfil1,tp,0x01,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
