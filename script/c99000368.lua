--MEIYAKU@SPELL
local m=99000368
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
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e1:SetCost(cm.cost)
	e1:SetCondition(cm.tdcon)
	e1:SetTarget(cm.tdtg)
	e1:SetOperation(cm.tdop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--banished
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCondition(cm.bncon)
	e4:SetTarget(cm.bntg)
	e4:SetOperation(cm.bnop)
	c:RegisterEffect(e4)
end
function cm.meiyakutg(e,te,tp)
	local c=e:GetHandler()
	local tc=te:GetHandler()
	return c==tc and not tc:IsLocation(LOCATION_SZONE) and te:IsHasType(EFFECT_TYPE_ACTIVATE) 
end
function cm.meiyakuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,99000371,0,0x4011,1000,1000,1,RACE_WARRIOR,ATTRIBUTE_LIGHT,POS_FACEUP,1-tp)
		and Duel.SelectYesNo(tp,aux.Stringid(99000306,0)) then
		local token=Duel.CreateToken(tp,99000371)
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
		or (Duel.IsPlayerAffectedByEffect(tp,99000305) and e:GetHandler():GetFlagEffect(99000368)==0) end
	if Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_GRAVE,0,1,nil)
		and (not Duel.IsPlayerAffectedByEffect(tp,99000305) or e:GetHandler():GetFlagEffect(99000368)~=0
		or not Duel.SelectYesNo(tp,aux.Stringid(99000305,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	else
		e:GetHandler():RegisterFlagEffect(99000368,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOwner()==tp
end
function cm.filter(c,tp,col)
	return c:GetSummonPlayer()==tp and col==aux.GetColumn(c) and c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local col=aux.GetColumn(e:GetHandler())
	if chk==0 then return eg:IsExists(cm.filter,1,nil,1-tp,col) end
	local g=eg:Filter(cm.filter,nil,1-tp,col)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function cm.bncon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return c:IsReason(REASON_COST) and rc:IsType(TYPE_SPELL)
end
function cm.bntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,99000368)==0 end
end
function cm.bnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetValue(cm.effectfilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,99000368,RESET_PHASE+PHASE_END,0,1)
end
function cm.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and (te:GetHandler():IsSetCard(0xc13) or te:GetHandler():IsSetCard(0xc16))
end