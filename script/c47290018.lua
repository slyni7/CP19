--타임글래스 필그림&리퍼
local m=47290018
local cm=_G["c"..m]

function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddOrderProcedure(c,"<",nil,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO),cm.ordfil1,aux.FilterBoolFunction(Card.IsRace,RACE_PSYCHO))

	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)

	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)

	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.rmtg)
	e2:SetOperation(cm.rmop)
	c:RegisterEffect(e2)


	--change atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.uptar)
	e3:SetValue(cm.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)

	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.CardType_Order=true

function cm.ordfil1(c)
	return c:IsType(TYPE_ORDER) and c:IsSetCard(0x429)
end

function cm.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_ORDER)==SUMMON_TYPE_ORDER
end

function cm.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end


function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end

function cm.filter(c,turn)
	return (c:IsLocation(LOCATION_MZONE) or c:GetFlagEffect(m)~=0) and c:GetTurnID()==turn and c:IsAbleToRemove()
end

function cm.tdfilter(c)
	return c:IsSetCard(0x429) and c:IsAbleToDeck() and c:IsFaceup()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.tdfilter,tp,LOCATION_REMOVED,0,3,nil) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,Duel.GetTurnCount()) end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local dg=Duel.SelectTarget(tp,cm.tdfilter,tp,LOCATION_REMOVED,0,3,3,nil)

	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,Duel.GetTurnCount())

	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,dg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)

	Duel.SetChainLimit(cm.chlimit)
end

function cm.chlimit(e,ep,tp)
	return tp==ep
end

function cm.rmop(e,tp,eg,ep,ev,re,r,rp)

	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)

	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end

	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)

	local og=Duel.GetOperatedGroup()

	if og:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end

	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)

	if ct>0 then

		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,Duel.GetTurnCount())

		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end

	end
end

function cm.uptar(e,c)
	return c:IsSetCard(0x429)
end

function cm.val(e,c)
	return Duel.GetMatchingGroupCount(nil,0,LOCATION_REMOVED,LOCATION_REMOVED,nil)*100
end