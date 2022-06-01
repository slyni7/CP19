--[Forest]
local m=99970504
local cm=_G["c"..m]
function cm.initial_effect(c)

	--특수 소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	
	--서치
	local e2=MakeEff(c,"Qo","M")
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,m)
	e2:SetCost(spinel.relcost)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	
	--카운터 + 회복
	local e3=MakeEff(c,"I","G")
	e3:SetCategory(CATEGORY_COUNTER+CATEGORY_RECOVER)
	e3:SetCost(spinel.tdcost)
	e3:SetCondition(aux.exccon)
	WriteEff(e3,3,"TO")
	c:RegisterEffect(e3)

end

--특수 소환
function cm.spfil(c)
	return c:IsFaceup() and c:IsCode(99970501)
end
function cm.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfil,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end

--서치
function cm.thfilter(c)
    return c:IsSetCard(0xe0c) and c:IsType(YuL.ST) and c:IsAbleToHand()
end
function cm.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end

--카운터 + 회복
function cm.filter(c)
	return c:IsFaceup() and c:IsCode(99970501)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1052,1,REASON_EFFECT)
		tc=g:GetNext()
	end
	if Duel.GetCounter(tp,1,0,0x1052)>0 then
		Duel.BreakEffect()
		Duel.Recover(tp,Duel.GetCounter(tp,1,0,0x1052)*200,REASON_EFFECT)
	end
end
