--Nellaf Nosmirc
local m=99970511
local cm=_G["c"..m]
function cm.initial_effect(c)

	--NOSMIRC
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--드로우
	local e2=MakeEff(c,"STf")
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetCode(EVENT_TO_GRAVE)
	WriteEff(e2,2,"NO")
	c:RegisterEffect(e2)
	
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0	
	end
end

--NOSMIRC
function cm.thfilter(c)
	return c:IsSetCard(0xe0d) and bit.band(c:GetType(),0x20004)==0x20004 and c:IsAbleToHand()
end
function cm.thfilter2(c)
	return c:IsSetCard(0xe0d) and bit.band(c:GetType(),0x20004)==0x20004
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter2,tp,LSTN("DG"),0,1,nil) end
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	cm[tp],cm[1-tp]=cm[tp]+1,cm[1-tp]+1
	local ct=6-cm[tp]
	if ct<0 then ct=0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(ct)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.thcon)
	e2:SetOperation(cm.thop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LSTN("DG"),0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LSTN("DG"),0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--드로우
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and e:GetHandler():IsReason(REASON_EFFECT)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(cm.drop)
	Duel.RegisterEffect(e1,tp)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,m)
	Duel.Draw(tp,1,REASON_EFFECT)
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.Draw(1-tp,1,REASON_EFFECT)
	if bit.band(c:GetType(),0x20004)==0x20004 and not tc:IsPublic() then
		Duel.ConfirmCards(1-tp,tc)
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)-1000)
	end
end
