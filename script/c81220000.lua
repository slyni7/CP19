--공허의 율자
local m=81220000
local cm=_G["c"..m]
function cm.initial_effect(c)

	--ability
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetCost(cm.co1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.co3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end

--ability
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_DECK) and c:IsLocation(LOCATION_HAND)
end
function cm.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return not e:GetHandler():IsPublic()
	end
end
function cm.tfil0(c)
	return c:IsSSetable() and c:IsSetCard(0xcbb) and c:IsType(0x2+0x04)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=0x01
	if Duel.GetCurrentPhase()==PHASE_DRAW and e:GetHandler():IsReason(REASON_RULE) then
		loc=loc+0x10
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,0x08)>0
		and Duel.IsExistingMatchingCard(cm.tfil0,tp,loc,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end
function cm.field_select(g,ft)
	local fg=g:FilterCount(Card.IsType,nil,TYPE_FIELD)
	return fg<=1 and aux.dncheck(g) and #g-fg<=ft
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local loc=0x01
	local ct=1
	if Duel.GetCurrentPhase()==PHASE_DRAW and e:GetHandler():IsReason(REASON_RULE) then
		loc=loc+0x10
		ct=ct+1
	end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tfil0),tp,loc,0,nil)
	local ft=Duel.GetLocationCount(tp,0x08)
	if #g==0 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tg=g:SelectSubGroup(tp,cm.field_select,false,1,math.min(ct,ft+1),ft)
	Duel.SSet(tp,tg)
end	

--deck
function cm.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsAbleToDeck()
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end
end
