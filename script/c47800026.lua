--영혼의 절규
function c47800026.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCountLimit(1,47800026)
	e1:SetCost(c47800026.sgcost)
	e1:SetCondition(c47800026.con1)
	e1:SetTarget(c47800026.tdtg)	
	e1:SetOperation(c47800026.tdop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(47800026,ACTIVITY_CHAIN,aux.FALSE)
end
function c47800026.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(47800026,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c47800026.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x49e)
end
function c47800026.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c47800026.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED)<=120
end

function c47800026.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,g:GetCount())
end
function c47800026.cfilter(c,p)
	return c:IsLocation(LOCATION_DECK) and c:GetOwner()==p
end
function c47800026.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 and Duel.SendtoDeck(g,1-tp,2,REASON_EFFECT)>0 then
		local ct=g:FilterCount(c47800026.cfilter,nil,1-tp)
		if ct>0 then
			Duel.ShuffleDeck(1-tp)
			Duel.BreakEffect()
			Duel.Draw(1-tp,ct,REASON_EFFECT)
		end
	end
end