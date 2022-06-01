--[ Ironclad ]
local m=99970795
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	YuL.ExLimit(c)
	aux.AddFusionProcFun2(c,aux.FBF(Card.IsFusionSetCard,0xad6d),aux.FBF(Card.IsDefenseAbove,3000),true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)

	--Ironclad
	local e9=MakeEff(c,"Qo","M")
	e9:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCL(1)
	e9:SetCondition(cm.maincon)
	WriteEff(e9,9,"O")
	c:RegisterEffect(e9)
	
	--서치 / 덤핑
	local e1=MakeEff(c,"FTf","M")
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCL(1)
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
end

--Ironclad
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	local opt=0
	if Duel.IsAbleToEnterBP() then
		opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))+1
	else opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))+1 end
	local c=e:GetHandler()
	local defC=3000
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
		elseif opt==3 then
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(3205)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DIRECT_ATTACK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3)
		end
	end
end

--서치 / 덤핑
function cm.tar1fil(c)
	return c:IsSetCard(0xad6d) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end


function cm.maincon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
