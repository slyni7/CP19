--아크리스탤지아 베스
local m=99000342
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--handes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(cm.hdop)
	c:RegisterEffect(e3)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.tdcon)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
end
function cm.hdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,99000342)>0 then return end
	if e:GetHandler():GetFlagEffect(1)==0 then return end
	if not re:IsActiveType(TYPE_EFFECT) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsContains(e:GetHandler()) then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		if h1<1 or h2<1 then return end
		Duel.Hint(HINT_CARD,0,m)
		local turnp=Duel.GetTurnPlayer()
		Duel.Hint(HINT_SELECTMSG,turnp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(turnp,aux.TRUE,turnp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-turnp,g1)
		Duel.Hint(HINT_SELECTMSG,1-turnp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(1-turnp,aux.TRUE,1-turnp,LOCATION_HAND,0,1,1,nil)
		g1:Merge(g2)
		Duel.Destroy(g1,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,99000342,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsControler(1-tp) and bc:IsRelateToBattle()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetLabelObject()
	if chk==0 then return bc:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,bc,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() and bc:IsControler(1-tp) then
		Duel.SendtoDeck(bc,nil,2,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		Duel.ChainAttack()
	end
end