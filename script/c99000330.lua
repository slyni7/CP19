--소원과 감정, 그리고 운명의 마녀
local m=99000330
local cm=_G["c"..m]
function cm.initial_effect(c)
	--base attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SET_BASE_ATTACK)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(2500)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,m+2000)
	e4:SetCost(cm.thcost)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
		and #g>0 and g:FilterCount(cm.cfilter,nil)==#g
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local att=0
	if Duel.GetFlagEffect(tp,99000328+1)~=0 then att=att+ATTRIBUTE_EARTH end
	if Duel.GetFlagEffect(tp,99000328+2)~=0 then att=att+ATTRIBUTE_WATER end
	if Duel.GetFlagEffect(tp,99000328+3)~=0 then att=att+ATTRIBUTE_FIRE end
	if Duel.GetFlagEffect(tp,99000328+4)~=0 then att=att+ATTRIBUTE_WIND end
	if Duel.GetFlagEffect(tp,99000328+5)~=0 then att=att+ATTRIBUTE_LIGHT end
	if Duel.GetFlagEffect(tp,99000328+6)~=0 then att=att+ATTRIBUTE_DARK end
	if Duel.GetFlagEffect(tp,99000328+7)~=0 then att=att+ATTRIBUTE_DIVINE end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetLabel(att)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetLabel(att)
	e2:SetTarget(cm.atktarget)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and c:IsAttribute(e:GetLabel())
end
function cm.atktarget(e,c)
	return c:IsAttribute(e:GetLabel())
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99000330)==0 and not Duel.IsPlayerAffectedByEffect(tp,99000326)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,99000330)==0 and Duel.IsPlayerAffectedByEffect(tp,99000326)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function cm.xyzlv(e,c,rc)
	return e:GetHandler():GetLevel()+e:GetLabel()*0x10000
end
function cm.tgfilter(c,e,tp,ec)
	local mg=Group.FromCards(ec,c)
	local e1=nil
	local e2=nil
	if c:IsLevelAbove(1) and ec:IsLevelAbove(1) then
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_XYZ_LEVEL)
		e1:SetValue(cm.xyzlv)
		e1:SetLabel(ec:GetLevel())
		c:RegisterEffect(e1,true)
		e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetValue(cm.xyzlv)
		e2:SetLabel(c:GetLevel())
		ec:RegisterEffect(e2,true)
	end
	local res=Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,mg,2,2)
	if e1 then e1:Reset() end
	if e2 then e2:Reset() end
	local att=0
	if Duel.GetFlagEffect(tp,99000328+1)~=0 then att=att+ATTRIBUTE_EARTH end
	if Duel.GetFlagEffect(tp,99000328+2)~=0 then att=att+ATTRIBUTE_WATER end
	if Duel.GetFlagEffect(tp,99000328+3)~=0 then att=att+ATTRIBUTE_FIRE end
	if Duel.GetFlagEffect(tp,99000328+4)~=0 then att=att+ATTRIBUTE_WIND end
	if Duel.GetFlagEffect(tp,99000328+5)~=0 then att=att+ATTRIBUTE_LIGHT end
	if Duel.GetFlagEffect(tp,99000328+6)~=0 then att=att+ATTRIBUTE_DARK end
	if Duel.GetFlagEffect(tp,99000328+7)~=0 then att=att+ATTRIBUTE_DIVINE end
	return res and c:IsFaceup() and c:IsAttribute(att)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.RegisterFlagEffect(tp,99000330+1000,RESET_PHASE+PHASE_END,0,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e3=nil
		local e4=nil
		if c:IsLevelAbove(1) and tc:IsLevelAbove(1) then
			e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_XYZ_LEVEL)
			e3:SetValue(cm.xyzlv)
			e3:SetLabel(tc:GetLevel())
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e3,true)
			e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_XYZ_LEVEL)
			e4:SetValue(cm.xyzlv)
			e4:SetLabel(c:GetLevel())
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4,true)
		end
		local mg=Group.FromCards(c,tc)
		local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,mg,2,2)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,mg)
		else
			if e3 then e3:Reset() end
			if e4 then e4:Reset() end
		end
	end
end
function cm.cfilter2(c)
	return c:GetTextAttack()==-2 and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thfilter(c)
	return (c:IsCode(54360049) or aux.IsCodeListed(c,54360049) and c:IsType(TYPE_SPELL)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end