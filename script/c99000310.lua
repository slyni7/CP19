--°¥¸ÁÇÏ´Â ÀÚÀÇ ¸Í¾à
local m=99000310
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Meiyaku
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetCode(EFFECT_ACTIVATE_COST)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	ea:SetTargetRange(1,1)
	ea:SetTarget(cm.meiyakutg)
	ea:SetOperation(cm.meiyakuop)
	Duel.RegisterEffect(ea,0)
	--remain field
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_SINGLE)
	eb:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(eb)
	--Activate
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_ACTIVATE)
	ec:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(ec)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.negcon)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
end
function cm.meiyakutg(e,te,tp)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return c==tc and not tc:IsLocation(LOCATION_SZONE) and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.meiyakuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99000297,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp)
		and Duel.SelectYesNo(tp,aux.Stringid(99000306,0)) then
		local token=Duel.CreateToken(tp,99000297)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
		Duel.MoveToField(c,tp,1-tp,LOCATION_FZONE,POS_FACEUP,false)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,67)
	else
		return true
	end
end
function cm.costfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		or (Duel.IsPlayerAffectedByEffect(tp,99000305) and e:GetHandler():GetFlagEffect(99000310)==0) end
	if Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		and (not Duel.IsPlayerAffectedByEffect(tp,99000305) or e:GetHandler():GetFlagEffect(99000310)~=0
		or not Duel.SelectYesNo(tp,aux.Stringid(99000305,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
		e:GetHandler():RegisterFlagEffect(99000310,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOwner()==tp and Duel.IsChainNegatable(ev) and ep==1-tp
		and e:GetHandler():GetColumnGroup():IsContains(re:GetHandler())
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function cm.cfilter(c,code)
	return c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=re:GetHandler()
	if Duel.IsChainDisablable(0) then
		local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_DECK+LOCATION_EXTRA,nil,tc:GetCode())
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(86937530,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoGrave(sg,REASON_EFFECT)
			Duel.NegateEffect(0)
			return
		end
	end
	Duel.NegateActivation(ev)
end