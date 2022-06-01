--P.S.(패러다임 시프트) A.N.U.
local m=112501006
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xe7b),aux.FilterBoolFunction(Card.IsType,TYPE_UNION),true)
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
	--Exile
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetRange(LOCATION_MZONE+LOCATION_REMOVED)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
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
	return c:IsType(TYPE_FUSION) or tp==ep
end

--Exile
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetChainLimit(cm.clim1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,-2,REASON_EFFECT)
	end
end

--EX Summon
function cm.exfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true)
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
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end