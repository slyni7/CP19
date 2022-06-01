--아이리 #CHA.OS(Conflict of Highlight After Opening Stage)
local m=112603045
local cm=_G["c"..m]
function cm.initial_effect(c)

	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetRange(LOCATION_HAND)
	e6:SetCountLimit(1)
	e6:SetTarget(cm.sptg1)
	e6:SetOperation(cm.spop1)
	c:RegisterEffect(e6)
	
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
	
	--equip
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(m,0))
	ea:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ea:SetCategory(CATEGORY_EQUIP)
	ea:SetType(EFFECT_TYPE_QUICK_O)
	ea:SetCode(EVENT_FREE_CHAIN)
	ea:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	ea:SetRange(LOCATION_MZONE+LOCATION_HAND)
	ea:SetTarget(cm.eqtg0)
	ea:SetOperation(cm.eqop0)
	c:RegisterEffect(ea)
	
	--unequip
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(m,1))
	eb:SetCategory(CATEGORY_SPECIAL_SUMMON)
	eb:SetType(EFFECT_TYPE_QUICK_O)
	eb:SetCode(EVENT_FREE_CHAIN)
	eb:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	eb:SetRange(LOCATION_SZONE)
	eb:SetTarget(cm.sptg0)
	eb:SetOperation(cm.spop0)
	c:RegisterEffect(eb)
	
	--destroy sub
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_TYPE_EQUIP)
	ec:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ec:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	ec:SetValue(cm.repval0)
	c:RegisterEffect(ec)

	--eqlimit
	local ed=Effect.CreateEffect(c)
	ed:SetType(EFFECT_TYPE_SINGLE)
	ed:SetCode(EFFECT_EQUIP_LIMIT)
	ed:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	ed:SetValue(cm.eqlimit)
	c:RegisterEffect(ed)

end

--eqlimit
function cm.eqlimit(e,c)
	return c:IsSetCard(0xe91) or e:GetHandler():GetEquipTarget()==c
end


--equip
function cm.filter0(c)
	local ct1,ct2=c:GetUnionCount()
	return c:IsFaceup() and c:IsSetCard(0xe91) and ct2==0
end
function cm.eqtg0(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter0(chkc) end
	if chk==0 then return e:GetHandler():GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.filter0,tp,LOCATION_MZONE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cm.filter0,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.eqop0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or not cm.filter0(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc) then return end
	aux.SetUnionState(c)
end

--unequip
function cm.sptg0(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	c:RegisterFlagEffect(m,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function cm.spop0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
end

--destroy sub
function cm.repval0(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end

--spsummon
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe91) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_SZONE)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_SZONE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--immune
function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end