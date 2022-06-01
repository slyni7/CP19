--Code Name: Vega
local m=99000198
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
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
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
	--half atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(cm.myucon)
	e4:SetValue(cm.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e5:SetValue(cm.defval)
	c:RegisterEffect(e5)
end
function cm.myucon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:GetOwner()==1-tp
end
function cm.myuop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(99000198,RESET_EVENT+RESETS_STANDARD,0,0)
end
function cm.myulimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetFlagEffect(99000198)>0
end
function cm.myureptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and not (re:IsActiveType(TYPE_MONSTER) and
		re:GetHandler():IsSetCard(0x1c20) and bit.band(r,REASON_EFFECT)~=0) end
	return true
end
function cm.myurepval(e,c)
	return true
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x1c20) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	local spos=0
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then spos=spos+POS_FACEUP_ATTACK end
	if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) then spos=spos+POS_FACEDOWN_DEFENSE end
	if spos~=0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,spos)~=0 then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.ceil(atk/2))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(math.ceil(def/2))
		tc:RegisterEffect(e2,true)
		Duel.SpecialSummonComplete()
		if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
		if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.SendtoHand(c,1-tp,REASON_EFFECT)
		Duel.ConfirmCards(tp,c)
		end
	end
end
function cm.costfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToGraveAsCost()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
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
function cm.atkval(e,c)
	return math.ceil(c:GetAttack()/2)
end
function cm.defval(e,c)
	return math.ceil(c:GetDefense()/2)
end