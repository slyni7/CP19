--P.S.(패러다임 시프트) To Leading Arip
local m=112501010
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Post Script
	kaos.shiftgamestart(c)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e2:SetCode(EFFECT_TO_HAND_REDIRECT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)
	--limit
	local e16=Effect.CreateEffect(c)
	e16:SetDescription(aux.Stringid(m,0))
	e16:SetType(EFFECT_TYPE_QUICK_O)
	e16:SetCode(EVENT_FREE_CHAIN)
	e16:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e16:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e16:SetCountLimit(1)
	e16:SetCondition(cm.limcon)
	e16:SetTarget(cm.limtg)
	e16:SetOperation(cm.limop)
	c:RegisterEffect(e16)
	--EX Summon
	local e30=Effect.CreateEffect(c)
	e30:SetDescription(aux.Stringid(m,1))
	e30:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e30:SetType(EFFECT_TYPE_QUICK_O)
	e30:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e30:SetCode(EVENT_FREE_CHAIN)
	e30:SetCountLimit(1)
	e30:SetHintTiming(0,TIMING_MAIN_END+TIMING_BATTLE_START+TIMING_BATTLE_END)
	e30:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e30:SetCost(kaos.onecost)
	e30:SetTarget(cm.extg)
	e30:SetOperation(cm.exop)
	c:RegisterEffect(e30)
end

--CHAIN
function cm.clim1(e,ep,tp)
	local c=e:GetHandler()
	return c:IsType(TYPE_LINK) or tp==ep
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
	return rc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA)
end

--EX Summon
function cm.exfilter(c,e,tp)
	return c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,true)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.filter1(c)
	return c:IsSetCard(0xe7b) and c:IsAbleToDeck()
end
function cm.extg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,2,nil) 
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
			and Duel.IsExistingMatchingCard(cm.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
				end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetChainLimit(cm.clim1)
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g1=Duel.GetOperationInfo(0,CATEGORY_TODECK)
	if g1:GetFirst():IsRelateToEffect(e) and g1:GetNext():IsRelateToEffect(e) then
		Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	end
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local h=Duel.SelectMatchingCard(tp,cm.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=h:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end