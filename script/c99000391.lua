--에페르 오브 에퀴드
local m=99000391
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetCode(EFFECT_SPSUMMON_CONDITION)
	ea:SetValue(aux.ritlimit)
	c:RegisterEffect(ea)
	--spsummon
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(99000386,0))
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	eb:SetCode(EFFECT_SPSUMMON_PROC)
	eb:SetRange(LOCATION_HAND+LOCATION_DECK)
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
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.hspfilter(c,tp,sc)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()>=5
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeRitualMaterial(sc,SUMMON_TYPE_SPECIAL)
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
	return bc and bc:IsAttribute(0x7e) and c:GetSummonType()&SUMMON_TYPE_RITUAL==SUMMON_TYPE_RITUAL
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
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsSummonableCard() and c:IsAbleToHand()
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
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if chk==0 then return not eg:IsContains(e:GetHandler()) and ct>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,ct,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local ct=g:GetCount()-Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	if ct<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local dg=g:FilterSelect(tp,Card.IsAbleToGrave,ct,ct,nil)
	Duel.SendtoGrave(dg,REASON_EFFECT)
end