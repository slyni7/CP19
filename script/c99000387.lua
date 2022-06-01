--에페르 오브 클락
local m=99000387
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,3)
	c:EnableReviveLimit()
	--spsummon condition
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetCode(EFFECT_SPSUMMON_CONDITION)
	ea:SetValue(aux.xyzlimit)
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
	--time machine
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.hspfilter(c,tp,sc)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()>=5
		and c:IsControler(tp) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
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
	return bc and bc:IsAttribute(0x6f) and c:GetSummonType()&SUMMON_TYPE_XYZ==SUMMON_TYPE_XYZ
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
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsSummonableCard() and c:IsAbleToHand()
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
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tc:GetPreviousControler(),LOCATION_MZONE)>0 and eg:GetCount()==1
		and tc:IsType(TYPE_MONSTER) and tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsLocation(LOCATION_GRAVE) end
	tc:CreateEffectRelation(e)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	if tc and tc:IsRelateToEffect(e)
		and Duel.MoveToField(tc,tc:GetPreviousControler(),tc:GetPreviousControler(),LOCATION_MZONE,tc:GetPreviousPosition(),true)~=0 then
		tc:SetStatus(STATUS_SPSUMMON_STEP,false)
		tc:SetStatus(STATUS_SPSUMMON_TURN,true)
		local g=c:GetOverlayGroup():Filter(Card.IsAbleToHand,nil)
		if c:IsRelateToEffect(e) and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end