--[KATANAGATARI]
local m=99970313
local cm=_G["c"..m]
function cm.initial_effect(c)

	--장착
	YuL.Equip(c)

	--칼의 독
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD)
	e0:SetOperation(cm.katana)
	c:RegisterEffect(e0)
	
	--공수 증가
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)

	--가장 많은 칼: 천도순례
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(YuL.phase(2,PHASE_MAIN1+PHASE_MAIN2))
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)

end

--칼의 독
function cm.katana(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetEquipTarget()
	if tc and e:GetHandler():IsReason(REASON_EFFECT) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

--가장 많은 칼: 천도순례
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local token=Duel.CreateToken(tp,m)
	Duel.SendtoHand(token,nil,REASON_RULE)
	Duel.ConfirmCards(1-tp,token)
end
