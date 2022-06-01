--P.S.(패러다임 시프트) 리스펙트
local m=112501002
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Post Script
	kaos.paradigmestart(c)
	--UNION
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY)
	e0:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_TUNER)
	c:RegisterEffect(e0)
	--Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,5))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.negcon)
	e3:SetTarget(cm.negtg)
	e3:SetOperation(cm.negop)
	c:RegisterEffect(e3)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,6))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetTarget(cm.sptg)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--F Summon
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(m,0))
	e20:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e20:SetType(EFFECT_TYPE_QUICK_O)
	e20:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e20:SetCode(EVENT_FREE_CHAIN)
	e20:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e20:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e20:SetCost(kaos.pscost)
	e20:SetTarget(cm.pstgFusion)
	e20:SetOperation(kaos.psopFusion)
	c:RegisterEffect(e20)
	--R Summon
	local e21=Effect.CreateEffect(c)
	e21:SetDescription(aux.Stringid(m,1))
	e21:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e21:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e21:SetCost(kaos.pscost)
	e21:SetTarget(cm.pstgRitual)
	e21:SetOperation(kaos.psopRitual)
	c:RegisterEffect(e21)
	--S Summon
	local e22=Effect.CreateEffect(c)
	e22:SetDescription(aux.Stringid(m,2))
	e22:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e22:SetType(EFFECT_TYPE_QUICK_O)
	e22:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e22:SetCode(EVENT_FREE_CHAIN)
	e22:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e22:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e22:SetCost(kaos.pscost)
	e22:SetTarget(cm.pstgSynchro)
	e22:SetOperation(kaos.psopSynchro)
	c:RegisterEffect(e22)
	--X Summon
	local e23=Effect.CreateEffect(c)
	e23:SetDescription(aux.Stringid(m,3))
	e23:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e23:SetType(EFFECT_TYPE_QUICK_O)
	e23:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e23:SetCode(EVENT_FREE_CHAIN)
	e23:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e23:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e23:SetCost(kaos.pscost)
	e23:SetTarget(cm.pstgXyz)
	e23:SetOperation(kaos.psopXyz)
	c:RegisterEffect(e23)
	--L Summon
	local e24=Effect.CreateEffect(c)
	e24:SetDescription(aux.Stringid(m,4))
	e24:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e24:SetType(EFFECT_TYPE_QUICK_O)
	e24:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e24:SetCode(EVENT_FREE_CHAIN)
	e24:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e24:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e24:SetCost(kaos.pscost)
	e24:SetTarget(cm.pstgLink)
	e24:SetOperation(kaos.psopLink)
	c:RegisterEffect(e24)
end

--CHAIN
function cm.clim1(e,ep,tp)
	local c=e:GetHandler()
	return c:IsType(TYPE_TUNER) or tp==ep
end

--Negate
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		Duel.SetChainLimit(cm.clim1)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoDeck(eg,nil,-2,REASON_EFFECT)
	end
end

--search
function cm.cfilter(c)
	return c:IsSetCard(0xe7b)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_REMOVED,0,5,nil)
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0xe7b) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and c45885288.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetChainLimit(cm.clim1)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end


--F Summon
function cm.pstgFusion(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and Duel.IsExistingMatchingCard(kaos.spfilterFusion,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED)
	Duel.SetChainLimit(cm.clim1)

end

--R Summon
function cm.pstgRitual(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(kaos.spfilterRitual,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED)
	Duel.SetChainLimit(cm.clim1)

end

--S Summon
function cm.pstgSynchro(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(kaos.spfilterSynchro,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED)
	Duel.SetChainLimit(cm.clim1)
end

--X Summon
function cm.pstgXyz(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(kaos.spfilterXyz,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED)
	Duel.SetChainLimit(cm.clim1)
end

--L Summon
function cm.pstgLink(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_LMATERIAL)
		and Duel.IsExistingMatchingCard(kaos.spfilterLink,tp,LOCATION_EXTRA+LOCATION_REMOVED,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_REMOVED)
	Duel.SetChainLimit(cm.clim1)
end