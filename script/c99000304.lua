--Hidden Code: Helios
local m=99000304
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,m)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_HAND_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.condition)
	e3:SetValue(100)
	c:RegisterEffect(e3)
	--discard
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_HANDES)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.discon)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
	if not cm.global_flag then
		cm.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.CardType_Order=true
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if Duel.GetTurnPlayer()~=tp and bit.band(r,REASON_ADJUST)~=0 then
			Duel.RegisterFlagEffect(tp,m,0,0,0)
		end
	end
end
function cm.cfilter(c)
	return not c:IsAbleToDeckOrExtraAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0
		and not g:IsExists(cm.cfilter,1,nil) and Duel.GetFlagEffect(tp,m)>0
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x1c20) and c:IsType(TYPE_MONSTER)
end
function cm.condition(e)
	return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_HAND,1,nil)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=7
		and Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_HAND,1,nil)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,ht-6)
end
function cm.disfilter(c)
	return not (c:IsSetCard(0x1c20) and c:IsType(TYPE_MONSTER))
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local ht=Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)
	if ht>=7 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=Duel.SelectMatchingCard(1-tp,cm.disfilter,1-tp,LOCATION_HAND,0,ht-6,ht-6,nil)
		g:Merge(sg)
	end
	Duel.SendtoGrave(g,REASON_RULE+REASON_DISCARD)
	if Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>=7 then Duel.SwapDeckAndGrave(1-tp) end
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thfilter(c)
	return c:IsSetCard(0x1c20) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
		if tc and op==0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		elseif tc and op==1 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
			Duel.ConfirmCards(tp,g)
		end
	end
end