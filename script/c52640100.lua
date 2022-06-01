--필리플렉터 누르
local m=52640100
local cm=_G["c"..m]
function cm.initial_effect(c)
	--damage
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	ea:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	ea:SetCondition(cm.damcon)
	ea:SetOperation(cm.damop)
	c:RegisterEffect(ea)
	--damage
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	eb:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	eb:SetCondition(cm.damcon2)
	eb:SetOperation(cm.damop)
	c:RegisterEffect(eb)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,152640100)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	c:RegisterEffect(e2)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
   return ep~=tp
end
function cm.damcon2(e,tp,eg,ep,ev,re,r,rp)
   return ep==tp
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
   Duel.ChangeBattleDamage(1-ep,ev,false)
   Duel.ChangeBattleDamage(ep,0,false)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and Duel.GetTurnPlayer()==tp
end
function cm.filter(c)
	return c:IsSetCard(0x5fa) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x5fa) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,500)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		Duel.BreakEffect()
		Duel.Damage(tp,500,REASON_EFFECT)
	end
end
