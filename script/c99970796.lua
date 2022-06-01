--[ Ironclad ]
local m=99970796
local cm=_G["c"..m]
function cm.initial_effect(c)

	--융합 소환
	RevLim(c)
	YuL.ExLimit(c)
	aux.AddFusionProcFun2(c,aux.FBF(Card.IsFusionSetCard,0xad6d),aux.FBF(Card.IsDefenseAbove,6000),true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)
	
	--Ironclad
	local e9=MakeEff(c,"Qo","M")
	e9:SetD(m,3)
	e9:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCL(1)
	e9:SetCondition(cm.maincon)
	WriteEff(e9,9,"O")
	c:RegisterEffect(e9)
	
	--파괴
	local e1=MakeEff(c,"Qo","M")
	e1:SetD(m,4)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCL(1)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
end

--Ironclad
function cm.op9fil(c)
	return c:IsFaceup() and c:IsSetCard(0xad6d)
end
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(cm.op9fil,tp,LOCATION_MZONE,0,nil)
	if #tg>0 then
		opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1),aux.Stringid(m,2))+1
	else opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))+1 end
	local c=e:GetHandler()
	local defC=4000
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
			local sc=tg:GetFirst()
			for sc in aux.Next(tg) do
				local e3=Effect.CreateEffect(e:GetHandler())
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UPDATE_DEFENSE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e3:SetValue(2000)
				sc:RegisterEffect(e3)
			end
		end
	end
end

--파괴
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetDefense)>=16000
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if chk==0 then return #cg>1 and cg:GetClassCount(Card.GetCode)==#cg end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 and #cg>1 and cg:GetClassCount(Card.GetCode)==#cg then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end


function cm.maincon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
