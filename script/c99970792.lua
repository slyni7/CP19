--[ Ironclad ]
local m=99970792
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

	--수비력 증가
	local e1=MakeEff(c,"F","M")
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.tar1)
	e1:SetValue(2000)
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

--수비력 증가
function cm.tar1(e,c)
	return c:IsSetCard(0xad6d) and c~=e:GetHandler()
end


function cm.maincon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
