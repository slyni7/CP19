--인조천사 후밀리타스
local m=99000376
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Synthetic Seraphim
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(99000374,0))
	ea:SetCategory(CATEGORY_SUMMON)
	ea:SetType(EFFECT_TYPE_QUICK_O)
	ea:SetRange(LOCATION_HAND)
	ea:SetCode(EVENT_FREE_CHAIN)
	ea:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	ea:SetSpellSpeed(3)
	ea:SetCondition(cm.Synthetic_Seraphim_Condition1)
	ea:SetTarget(cm.Synthetic_Seraphim_Target)
	ea:SetOperation(cm.Synthetic_Seraphim_Operation)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(99000374,0))
	eb:SetCategory(CATEGORY_SUMMON)
	eb:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	eb:SetRange(LOCATION_HAND)
	eb:SetCode(EVENT_CHAINING)
	eb:SetProperty(EFFECT_FLAG_DELAY)
	eb:SetSpellSpeed(3)
	eb:SetCondition(cm.Synthetic_Seraphim_Condition2)
	eb:SetTarget(cm.Synthetic_Seraphim_Target)
	eb:SetOperation(cm.Synthetic_Seraphim_Operation)
	c:RegisterEffect(eb)
	--copy effect
	local ec=Effect.CreateEffect(c)
	ec:SetDescription(aux.Stringid(99000374,1))
	ec:SetCategory(CATEGORY_TODECK)
	ec:SetType(EFFECT_TYPE_ACTIVATE)
	ec:SetRange(LOCATION_MZONE)
	ec:SetCode(EVENT_FREE_CHAIN)
	ec:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ec:SetSpellSpeed(3)
	ec:SetCondition(cm.cpcon)
	ec:SetCost(cm.cpcost)
	ec:SetTarget(cm.cptg)
	ec:SetOperation(cm.cpop)
	c:RegisterEffect(ec)
	local ed=Effect.CreateEffect(c)
	ed:SetDescription(aux.Stringid(99000374,1))
	ed:SetCategory(CATEGORY_TODECK)
	ed:SetType(EFFECT_TYPE_ACTIVATE)
	ed:SetRange(LOCATION_MZONE)
	ed:SetCode(EVENT_SUMMON)
	ed:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ed:SetSpellSpeed(3)
	ed:SetCondition(cm.cpcon)
	ed:SetCost(cm.cpcost)
	ed:SetTarget(cm.cptg)
	ed:SetOperation(cm.cpop)
	c:RegisterEffect(ed)
	local ee=ed:Clone()
	ee:SetSpellSpeed(3)
	ee:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(ee)
	local ef=ed:Clone()
	ef:SetSpellSpeed(3)
	ef:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(ef)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetSpellSpeed(3)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetSpellSpeed(3)
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetSpellSpeed(3)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and (c:IsSetCard(0xc12) or c:IsCode(16946849))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsContains(e:GetHandler()) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
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
function cm.Synthetic_Seraphim_filter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsRace(RACE_FAIRY)
end
function cm.Synthetic_Seraphim_Condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.Synthetic_Seraphim_filter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
end
function cm.Synthetic_Seraphim_Condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_COUNTER)
end
function cm.Synthetic_Seraphim_Target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsSummonable(true,nil)
		and e:GetHandler():GetFlagEffect(m+99000380)==0
	end
	e:GetHandler():RegisterFlagEffect(m+99000380,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function cm.Synthetic_Seraphim_Operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Summon(tp,c,true,nil)~=0 then
		--nontuner
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_NONTUNER)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e1)
	end
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsStatus(STATUS_CHAINING)
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.cpfilter(c)
	aux.CheckDisSumAble=true
	if not (c:CheckActivateEffect(false,true,false)~=nil) then return false end
	aux.CheckDisSumAble=false
	return c:IsType(TYPE_COUNTER) and c:IsAbleToDeck()
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
		e:GetHandler():RegisterEffect(e1,true)
		local res=Duel.CheckLPCost(tp,math.min(e:GetHandler():GetAttack(),e:GetHandler():GetDefense()))
		local res2=Duel.IsExistingTarget(cm.cpfilter,tp,LOCATION_GRAVE,0,1,nil)
		e1:Reset()
		return res and res2
	end
	e:SetLabel(0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_TRAP+TYPE_COUNTER)
	e:GetHandler():RegisterEffect(e1,true)
	Duel.PayLPCost(tp,math.min(e:GetHandler():GetAttack(),e:GetHandler():GetDefense()))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	aux.CheckDisSumAble=true
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	aux.CheckDisSumAble=false
	e1:Reset()
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,2,REASON_EFFECT)
end