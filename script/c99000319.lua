--순백의 바운티헌터
local m=99000319
local cm=_G["c"..m]
function cm.initial_effect(c)
	--summon limit
	local ea=Effect.CreateEffect(c)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(ea)
	local eb=ea:Clone()
	eb:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(eb)
	--spsummon limit
	local ec=Effect.CreateEffect(c)
	ec:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ec:SetType(EFFECT_TYPE_SINGLE)
	ec:SetCode(EFFECT_SPSUMMON_CONDITION)
	ec:SetValue(aux.FALSE)
	c:RegisterEffect(ec)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(cm.actcost)
	e2:SetTarget(cm.acttg)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local ex1=re:IsHasCategory(CATEGORY_DRAW)
	local ex2=re:IsHasCategory(CATEGORY_SEARCH)
	return (ex1 or ex2) and rp==tp and Duel.IsChainDisablable(ev)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,99000319)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end
		Duel.RegisterFlagEffect(tp,99000319,0,0,1)
	end
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function cm.actfilter(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.actfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.actfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.actfilter,tp,0,LOCATION_MZONE,1,1,nil)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		ct=Duel.DiscardHand(tp,aux.TRUE,1,2,REASON_DISCARD+REASON_EFFECT)
	end
	local tc=Duel.GetFirstTarget()
	if ct>=0 then
		if tc:IsRelateToEffect(e) then
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
	if ct>=1 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(tp,g)
		local tg=g:Filter(Card.IsCode,nil,tc:GetCode())
		if ct==2 then
			local tg2=g:Filter(Card.IsRace,nil,tc:GetRace())
			local tg3=g:Filter(Card.IsAttribute,nil,tc:GetAttribute())
			tg:Merge(tg2)
			tg:Merge(tg3)
		end
		if tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			g=tg:Select(tp,1,1,nil)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
		Duel.ShuffleExtra(1-tp)
	end
end