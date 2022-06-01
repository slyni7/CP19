--±úÁ®¹ö¸° °í´ëÀÇ ¸Í¾à
local m=99000309
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
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.operation)
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
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99000296,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp)
		and Duel.SelectYesNo(tp,aux.Stringid(99000306,0)) then
		local token=Duel.CreateToken(tp,99000296)
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
		or (Duel.IsPlayerAffectedByEffect(tp,99000305) and e:GetHandler():GetFlagEffect(99000309)==0) end
	if Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		and (not Duel.IsPlayerAffectedByEffect(tp,99000305) or e:GetHandler():GetFlagEffect(99000309)~=0
		or not Duel.SelectYesNo(tp,aux.Stringid(99000305,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
		e:GetHandler():RegisterFlagEffect(99000309,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOwner()==tp
end
function cm.filter(c,g)
	return not g:IsContains(c)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	g1:Merge(g2)
	Duel.ConfirmCards(tp,g1)
	local tc=g1:GetFirst()
	local check=0
	while tc do
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,0,LOCATION_GRAVE,1,nil,tc:GetCode()) then
			check=check+1
		end
		tc=g1:GetNext()
	end
	local cg=c:GetColumnGroup()
	local dg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,cg)
	if check>0 and dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
	Duel.ShuffleHand(1-tp)
end