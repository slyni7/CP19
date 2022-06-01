--[ Ironclad ]
local m=99970794
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
	
	--특수 소환 + 세트
	local e1=MakeEff(c,"I","H")
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCL(1,m)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)

end

--Ironclad
function cm.op9(e,tp,eg,ep,ev,re,r,rp)
	local opt=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))+1
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
		end
	end
end

--특수 소환 + 세트
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetDefense)>=6000
end
function cm.tar1fil(c)
	return c:IsSetCard(0xad6d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.tar1fil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.tar1fil,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
		end
	end
end


function cm.maincon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
