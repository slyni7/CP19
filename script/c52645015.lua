--멜로위버 리와인드
local m=52645015
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,152645015)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_TO_GRAVE)
    e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,m)
    e2:SetTarget(cm.gvtg)
    e2:SetOperation(cm.gvop)
    c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_TODECK)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_REMOVE)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCountLimit(1,m)
    e3:SetTarget(cm.rmtg)
    e3:SetOperation(cm.rmop)
    c:RegisterEffect(e3)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeck() and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.IsPlayerCanDraw(tp,1) then
        c:CancelToGrave()
        if Duel.SendtoDeck(c,nil,2,REASON_EFFECT) then 
			Duel.ShuffleDeck(tp)
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
    end
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
        Duel.ShuffleDeck(tp)
        Duel.BreakEffect()
        Duel.Draw(tp,1,REASON_EFFECT)
    end
end
function cm.filter(c)
    return c:IsSetCard(0x5f5) and c:IsAbleToDeck()
end
function cm.gvtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
end
function cm.gvop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,nil)
    if g:GetCount()<3 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=g:Select(tp,3,3,nil)
    if Duel.SendtoDeck(sg,nil,0,REASON_EFFECT) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)~=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	else 
		Duel.ShuffleDeck(tp)
    end
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_REMOVED,0,3,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_REMOVED,0,nil)
    if g:GetCount()<3 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local sg=g:Select(tp,3,3,nil)
    if Duel.SendtoDeck(sg,nil,0,REASON_EFFECT) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)~=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)~=0 and Duel.SelectYesNo(tp,aux.Stringid(m,0))then
		Duel.ShuffleDeck(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		g1:Merge(g2)
		Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleDeck(1-tp)
	else 
		Duel.ShuffleDeck(tp)	
    end
end