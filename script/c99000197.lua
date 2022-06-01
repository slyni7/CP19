--Code Name: Capella
local m=99000197
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
	ed:SetType(EFFECT_TYPE_FIELD)
	ed:SetCode(EFFECT_PUBLIC)
	ed:SetCondition(cm.myucon)
	ed:SetRange(LOCATION_HAND)
	ed:SetTargetRange(LOCATION_HAND,0)
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
	--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
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
	e:GetHandler():RegisterFlagEffect(99000197,RESET_EVENT+RESETS_STANDARD,0,0)
end
function cm.myulimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetFlagEffect(99000197)>0
end
function cm.myureptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and not (re:IsActiveType(TYPE_MONSTER) and
		re:GetHandler():IsSetCard(0x1c20) and bit.band(r,REASON_EFFECT)~=0) end
	return true
end
function cm.myurepval(e,c)
	return true
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SendtoHand(c,1-tp,REASON_EFFECT)~=0 and Duel.ConfirmCards(tp,c)~=0 then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
function cm.costfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsAbleToGraveAsCost()
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