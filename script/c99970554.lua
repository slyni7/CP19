--[ Noblechain ]
local m=99970554
local cm=_G["c"..m]
function cm.initial_effect(c)

	--서치
	local e1=MakeEff(c,"I","M")
	e1:SetD(m,0)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCL(1)
	WriteEff(e1,1,"NTO")
	c:RegisterEffect(e1)
	
	--공수 증가
	local e2=MakeEff(c,"Qo","M")
	e2:SetD(m,1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(spinel.rmcost)
	e2:SetCondition(aux.not_damcal)
	WriteEff(e2,2,"O")
	c:RegisterEffect(e2)

	--노블체인
	local e0=MakeEff(c,"Qo","R")
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCL(1,m)
	WriteEff(e0,0,"NTO")
	c:RegisterEffect(e0)
	
end

--서치
function cm.con1filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe15) and c:IsType(TYPE_MONSTER)
end
function cm.con1(e)
	return Duel.IsExistingMatchingCard(cm.con1filter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,3,nil)
end
function cm.thfilter(c)
	return c:IsSetCard(0xe15) and c:IsType(YuL.ST) and c:IsAbleToHand()
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--공수 증가
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe15))
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end

--노블체인
function cm.con0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==2
end
function cm.tar0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lp=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)*500
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(lp-500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,lp-500)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			local lp=Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)*500
			Duel.Recover(p,lp,REASON_EFFECT)
		end
	end
end
