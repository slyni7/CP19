--Code Name: Procyon
local m=99000195
local cm=_G["c"..m]
function cm.initial_effect(c)
	--MyuMyuMyu
	local e0=Effect.CreateEffect(c)	
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetCountLimit(1)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(cm.myucon)
	e0:SetOperation(cm.myuop)
	c:RegisterEffect(e0)
	--disable summon
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_FIELD)
	ea:SetRange(LOCATION_HAND)
	ea:SetCode(EFFECT_CANNOT_SUMMON)
	ea:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ea:SetCondition(cm.myucon)
	ea:SetTargetRange(1,0)
	ea:SetTarget(cm.myulimit)
	c:RegisterEffect(ea)
	--disable set
	local eb=ea:Clone()
	eb:SetCode(EFFECT_CANNOT_MSET)
	c:RegisterEffect(eb)
	--disable spsummon
	local ec=ea:Clone()
	ec:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(ec)
	--public
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_SINGLE)
	ed:SetCode(EFFECT_PUBLIC)
	ed:SetCondition(cm.myucon)
	ed:SetRange(LOCATION_HAND)
	c:RegisterEffect(ed)
	--replace
   	local ee=Effect.CreateEffect(c)
	ee:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ee:SetCode(EFFECT_SEND_REPLACE)
	ee:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee:SetRange(LOCATION_HAND)
	ee:SetCondition(cm.myucon)
	ee:SetTarget(cm.myureptg)
	ee:SetValue(cm.myurepval)
	c:RegisterEffect(ee)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,m)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.reccon)
	e2:SetTarget(cm.rectg)
	e2:SetOperation(cm.recop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(cm.discost)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.myucon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:GetOwner()==1-tp
end
function cm.myuop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(99000195,RESET_EVENT+RESETS_STANDARD,0,0)
end
function cm.myulimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetFlagEffect(99000195)>0
end
function cm.myureptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and not (re:IsActiveType(TYPE_MONSTER) and
		re:GetHandler():IsSetCard(0x1c20) and bit.band(r,REASON_EFFECT)~=0) end
	return true
end
function cm.myurepval(e,c)
	return true
end
function cm.cfilter(c)
	return c:IsSetCard(0x1c20) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil)
	and e:GetHandler():IsAbleToHand() and c:GetFlagEffect(99000195)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
		Duel.SendtoHand(c,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,c)
	end
end
function cm.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOwner()==1-tp and Duel.GetTurnPlayer()==tp
end
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	local dam=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*200
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,dam)
end
function cm.recop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)*200
	Duel.Damage(p,dam,REASON_EFFECT)
end
function cm.costfilter(c)
	return c:IsType(TYPE_TRAP) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end