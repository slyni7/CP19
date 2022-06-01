--[ Ironclad ]
local m=99970791
local cm=_G["c"..m]
function cm.initial_effect(c)

	--Ironclad
	local e9=MakeEff(c,"Qo","M")
	e9:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCL(1)
	e9:SetCondition(cm.maincon)
	WriteEff(e9,9,"O")
	c:RegisterEffect(e9)
	
	--서치
	local e1=MakeEff(c,"STf")
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)

end

--Ironclad
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	local opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))+1
	local c=e:GetHandler()
	local defC=2000
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		if opt==1 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(defC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		elseif opt==2 then
			local at=c:GetDefense()-defC
			if at<0 then at=0 end
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(at)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
end

--서치
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and not c:IsLocation(LOCATION_DECK)
end
function cm.op1fil(c)
	return c:IsSetCard(0xad6d) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.op1fil,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.maincon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
