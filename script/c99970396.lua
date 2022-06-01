--주술명 【영혼엮기】
local m=99970396
local cm=_G["c"..m]
function cm.initial_effect(c)

	--회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	--자가 회수
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(spinel.delay)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	
	--상실 + 회복
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.condition)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
	
end

--회수
function cm.filter(c)
	return c:IsPosition(POS_ATTACK) and c:IsCanChangePosition()
end
function cm.filter2(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return e:GetHandler():IsAbleToDeck()
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	if Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) then
		e:SetCategory(CATEGORY_POSITION+CATEGORY_TODECK)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter2,tp,0,LOCATION_MZONE,nil)
	if c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0
			and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_MZONE,1,nil) then
			Duel.BreakEffect()
			Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
		end
	end
end

--자가 회수
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:GetHandler():IsCode(99970391)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3))
	end
end

--상실 + 회복
function cm.filter3(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSetCard(0xe1a) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter3,1,nil)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,lp-200)
	Duel.Recover(tp,200,REASON_EFFECT)
end
