--주술명 【니헬라의 허무】
local m=99970395
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
	
	--LP 조정
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(spinel.delay)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con)
	e2:SetOperation(cm.lpop)
	c:RegisterEffect(e2)

end

--회수
function cm.filter(c,e,tp)
	return c:IsCode(99970391) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
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
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,e,tp)
	if c:IsRelateToEffect(e) then
		c:CancelToGrave()
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 and #g>0
			and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
			and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

--LP 조정
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:GetHandler():IsCode(99970391)
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0 then return end
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3))
end
