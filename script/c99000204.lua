--Code Error: Luminous Star
local m=99000204
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCondition(cm.reccon)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc and rp==1-tp do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(99000204,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(99000204,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()~=tp
end
function cm.filter(c,id)
	return c:GetFlagEffect(99000204)>0 and c:IsReason(REASON_EFFECT) and c:GetTurnID()==id and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,Duel.GetTurnCount()) end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),PLAYER_ALL,LOCATION_GRAVE,Duel.GetTurnCount())
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,Duel.GetTurnCount())
	Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
	Duel.ConfirmCards(tp,sg)
end