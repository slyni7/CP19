--리믹스 #CHA.OS(Conflict of Highlight After Opening Stage)
local m=112603065
local cm=_G["c"..m]
function cm.initial_effect(c)

	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e4:SetCost(cm.spcost0)
	e4:SetCondition(cm.pccon)
	e4:SetTarget(cm.sptg1)
	e4:SetOperation(cm.spop1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e5:SetCost(cm.spcost0)
	e5:SetCondition(cm.sprcon)
	e5:SetTarget(cm.sptg1)
	e5:SetOperation(cm.spop1)
	c:RegisterEffect(e5)
	
	--create
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetOperation(cm.crop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,4))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCost(cm.spcost)
	e6:SetTarget(cm.sptg)
	e6:SetOperation(cm.spop)
	c:RegisterEffect(e6)
	
	--equip
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(m,0))
	ea:SetProperty(EFFECT_FLAG_CARD_TARGET)
	ea:SetCategory(CATEGORY_EQUIP)
	ea:SetType(EFFECT_TYPE_QUICK_O)
	ea:SetCode(EVENT_FREE_CHAIN)
	ea:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	ea:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
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

--special summon
function cm.spcost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.pccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function cm.cfilter(c)
	return c:IsFacedown() or c:IsSetCard(0xe91)
end
function cm.sprcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end

--create
function cm.crfilter(c)
	return c:IsSetCard(0xe91) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.crtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.crfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_EXTRA)
end
function cm.crop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,112603054)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112603055)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112603056)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112603057)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	local token=Duel.CreateToken(tp,112603058)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)

	
	
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.crfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.crlimit)
		tc:RegisterEffect(e1)
	end
end
function cm.crlimit(e,c)
	return e:GetOwner()==c
end

--spsummon
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0xe91) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
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