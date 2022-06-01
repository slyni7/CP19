--¿¡Æä¸£ ¿Àºê °ÔÈåÅ©µà¾Æ
local m=99000389
local cm=_G["c"..m]
function cm.initial_effect(c)
	--order summon
	aux.AddOrderProcedure(c,"R",nil,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),cm.ordfilter1,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE))
	c:EnableReviveLimit()
	--spsummon condition
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetCode(EFFECT_SPSUMMON_CONDITION)
	ea:SetValue(aux.ordlimit)
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
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.CardType_Order=true
function cm.ordfilter1(c)
	local lp=Duel.GetLP(1-c:GetControler())
	return c:IsAttackBelow(lp)
end
function cm.hspfilter(c,tp,sc)
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()>=5
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and c:IsCanBeOrderMaterial(sc,SUMMON_TYPE_SPECIAL)
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
	return bc and bc:IsAttribute(0x7b) and c:GetSummonType()&SUMMON_TYPE_ORDER==SUMMON_TYPE_ORDER
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
	return c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSummonableCard() and c:IsAbleToHand()
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
function cm.cfilter(c)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Damage(tp,tc:GetAttack(),REASON_EFFECT,true)
		Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT,true)
		Duel.RDComplete()
	end
end