--에페르 오브 듀제나
local m=99000388
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion summon
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),2,true)
	c:EnableReviveLimit()
	--spsummon condition
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetCode(EFFECT_SPSUMMON_CONDITION)
	ea:SetValue(aux.fuslimit)
	c:RegisterEffect(ea)
	--spsummon
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(99000386,0))
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	eb:SetCode(EFFECT_SPSUMMON_PROC)
	eb:SetRange(LOCATION_EXTRA)
	eb:SetCondition(cm.hspcon)
	eb:SetOperation(cm.hspop)
	c:RegisterEffect(eb)
	--destroy
	local ec=Effect.CreateEffect(c)
	ec:SetDescription(aux.Stringid(m,1))
	ec:SetCategory(CATEGORY_DESTROY)
	ec:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	ec:SetCode(EVENT_BATTLE_START)
	ec:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	ec:SetCondition(cm.epercon1)
	ec:SetTarget(cm.epertg1)
	ec:SetOperation(cm.eperop1)
	c:RegisterEffect(ec)
	--search
	local ed=Effect.CreateEffect(c)
	ed:SetDescription(aux.Stringid(m,2))
	ed:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	ed:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	ed:SetProperty(EFFECT_FLAG_DELAY)
	ed:SetCode(EVENT_DESTROYED)
	ed:SetCountLimit(1,m+10000+EFFECT_COUNT_CODE_DUEL)
	ed:SetCondition(cm.epercon2)
	ed:SetTarget(cm.epertg2)
	ed:SetOperation(cm.eperop2)
	c:RegisterEffect(ed)
	--virus
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.hspfilter(c,tp,sc)
	return c:IsFusionAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()>=5
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function cm.hspcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),cm.hspfilter,1,nil,c:GetControler(),c)
		and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,cm.hspfilter,1,1,nil,tp,c)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function cm.epercon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsAttribute(0x5f) and c:GetSummonType()&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function cm.epertg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function cm.eperop1(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function cm.epercon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==1-tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.eperfil(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsSummonableCard() and c:IsAbleToHand()
end
function cm.epertg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.eperfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.eperop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.eperfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,e:GetHandler(),ATTRIBUTE_DARK) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,e:GetHandler(),ATTRIBUTE_DARK)
	Duel.Release(g,REASON_COST)
end
function cm.tgfilter(c,rc)
	return c:IsFaceup() and c:IsRace(rc)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
	e:SetLabel(rc)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,0,LOCATION_MZONE,nil,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.filter(c,rc)
	return c:IsType(TYPE_MONSTER) and c:IsRace(rc)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetLabel()
	local conf=Duel.GetFieldGroup(tp,0,LOCATION_MZONE+LOCATION_HAND)
	if conf:GetCount()>0 then
		Duel.ConfirmCards(tp,conf)
		local dg=conf:Filter(cm.filter,nil,rc)
		Duel.Destroy(dg,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetOperation(cm.desop)
	e1:SetLabel(rc)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.turncon)
	e2:SetOperation(cm.turnop)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	Duel.RegisterEffect(e2,tp)
	e2:SetLabelObject(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	cm[e:GetHandler()]=e2
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if ep==e:GetOwnerPlayer() then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if hg:GetCount()==0 then return end
	Duel.ConfirmCards(1-ep,hg)
	local dg=hg:Filter(cm.filter,nil,e:GetLabel())
	Duel.Destroy(dg,REASON_EFFECT)
	Duel.ShuffleHand(ep)
end
function cm.turncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.turnop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	ct=ct+1
	e:SetLabel(ct)
	e:GetHandler():SetTurnCounter(ct)
	if ct==3 then
		e:GetLabelObject():Reset()
		e:GetOwner():ResetFlagEffect(1082946)
	end
end