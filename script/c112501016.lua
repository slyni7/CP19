--P.S.(패러다임 시프트) 레트로폴리스
local m=112501016
local cm=_G["c"..m]
function cm.initial_effect(c)
	--P Effect
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_EXTRA)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--limit
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(m,7))
	e16:SetType(EFFECT_TYPE_QUICK_O)
	e16:SetCode(EVENT_FREE_CHAIN)
	e16:SetRange(LOCATION_PZONE+LOCATION_REMOVED)
	e16:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e16:SetCountLimit(1)
	e16:SetCondition(cm.limcon)
	e16:SetTarget(cm.limtg)
	e16:SetOperation(cm.limop)
	c:RegisterEffect(e16)
	--EX Summon
	local e30=Effect.CreateEffect(c)
	e30:SetDescription(aux.Stringid(m,8))
	e30:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e30:SetType(EFFECT_TYPE_QUICK_O)
	e30:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e30:SetCode(EVENT_FREE_CHAIN)
	e30:SetCountLimit(1)
	e30:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e30:SetRange(LOCATION_PZONE+LOCATION_REMOVED)
	e30:SetCost(kaos.onecost)
	e30:SetTarget(cm.extg)
	e30:SetOperation(cm.exop)
	c:RegisterEffect(e30)
	
	--M Effect
	--Post Script
	kaos.paradigmestart(c)
	--FLIP
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY)
	e0:SetTargetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY,0)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_FLIP)
	c:RegisterEffect(e0)
	--pendulum set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,5))
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e6:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e6:SetCountLimit(1)
	e6:SetTarget(cm.rettg)
	e6:SetOperation(cm.retop)
	c:RegisterEffect(e6)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,6))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
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
	return c:IsType(TYPE_FLIP) or c:IsType(TYPE_PENDULUM) or tp==ep
end

--FLIP
function cm.paradigmshift(e,c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_FLIP)
end

--limit
function cm.limcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe7b)
end
function cm.limcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.limcfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.limtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(cm.clim1)
end
function cm.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_DECK+LOCATION_HAND)
end

--pendulum set
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then
      return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
   end
   Duel.SetChainLimit(cm.clim1)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
   local c=e:GetHandler()
   if not c:IsRelateToEffect(e) then
      return
   end
   if Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) then
      Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
   end
end

--search
function cm.cfilter(c)
	return c:IsSetCard(0xe7b)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_REMOVED,0,5,nil)
end
function cm.thfilter(c)
	return c:IsSetCard(0xe7b) and not c:IsCode(m) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_ONFIELD)
	Duel.SetChainLimit(cm.clim1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK+LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
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

--EX Summon
function cm.exfilter(c,e,tp,mc)
	return c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,true)
end
function cm.filter1(c)
	return c:IsSetCard(0xe7b) and c:IsAbleToDeck()
end
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.exfilter,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_PZONE)
	Duel.SetChainLimit(cm.clim1)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	if g1:GetFirst():IsRelateToEffect(e) and g1:GetNext():IsRelateToEffect(e) then
		Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.exfilter,tp,LOCATION_EXTRA+LOCATION_DECK+LOCATION_PZONE,0,1,1,nil,e,tp,nil):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end