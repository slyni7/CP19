--[Elder Dragon]
local m=99970522
local cm=_G["c"..m]
function cm.initial_effect(c)

	--듀얼
	aux.EnableDualAttribute(c)
	
	--Ok boomer
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e01:SetCode(EFFECT_IMMUNE_EFFECT)
	e01:SetRange(LOCATION_MZONE)
	e01:SetCondition(aux.IsDualState)
	e01:SetValue(cm.boomer)
	c:RegisterEffect(e01)
	
	--파괴
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCL(1)
	e1:SetCondition(aux.IsDualState)
	e1:SetCost(YuL.LPcost(1000))
	WriteEff(e1,1,"TO")
	c:RegisterEffect(e1)
	
	--서치
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	WriteEff(e2,2,"CTO")
	c:RegisterEffect(e2)
	
end

--Ok boomer
function cm.boomer(e,te)
	local tc=te:GetHandler()
	return ((te:IsActiveType(TYPE_MONSTER) and tc:IsStatus(STATUS_SPSUMMON_TURN))
		or (te:IsActiveType(YuL.ST) and tc:IsActivateTurn()))
		and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

--파괴
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0,nil)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

--서치
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.thfilter(c)
	return c:IsSetCard(0xd39) and c:IsType(TYPE_DUAL) and not c:IsCode(m) and c:IsAbleToHand()
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
