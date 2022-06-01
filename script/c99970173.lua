--모든 시간과 공간이 담긴 구슬
local m=99970173
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--회복
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetTarget(cm.rectg)
	e1:SetOperation(cm.recop)
	c:RegisterEffect(e1)

	--바벨의 도서관 접속
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.thcon)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)

	--자가 세트
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,199970173)
	e3:SetCost(YuL.discard(1,1))
	e3:SetCondition(cm.condition1)
	e3:SetTarget(cm.target1)
	e3:SetOperation(cm.activate1)
	c:RegisterEffect(e3)

end

--회복
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(99970172)
end
function cm.filter2(c)
	return c:IsSetCard(0xd3e) and c:IsAbleToHand()
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*600)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*600)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	if Duel.Recover(tp,ct*600,REASON_EFFECT)>0 then
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter2),tp,LOCATION_GRAVE,0,nil)
		if mg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

--바벨의 도서관 접속
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,99970172)
	Duel.SendtoHand(token,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,token)
end

--자가 세트
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
	end
end
