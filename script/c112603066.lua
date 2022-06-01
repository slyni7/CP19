--세상을 만드는 새로운 방법론
local m=112603066
local cm=_G["c"..m]
function cm.initial_effect(c)
	--act
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetRange(LOCATION_DECK+LOCATION_REMOVED+LOCATION_HAND)
	e0:SetCondition(cm.tdcon1)
	e0:SetTarget(cm.tdtg)
	e0:SetOperation(cm.tdop)
	c:RegisterEffect(e0)
	--act
	local e30=Effect.CreateEffect(c)
	e30:SetDescription(aux.Stringid(m,1))
	e30:SetType(EFFECT_TYPE_QUICK_O)
	e30:SetCode(EVENT_FREE_CHAIN)
	e30:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e30:SetRange(LOCATION_DECK+LOCATION_REMOVED+LOCATION_HAND)
	e30:SetCondition(cm.delcon)
	e30:SetTarget(cm.deltg)
	e30:SetOperation(cm.delop)
	c:RegisterEffect(e30)
	--immune
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_IMMUNE_EFFECT)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_ONFIELD+LOCATION_OVERLAY)
	e10:SetValue(cm.efilter)
	c:RegisterEffect(e10)
	--cannot disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e5)
end

--to deck
function cm.tdconfil1(c)
	return c:IsType(TYPE_UNION)
end
function cm.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tdconfil1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
end
function cm.tdfil1(c)
	return (c:IsType(TYPE_TUNER) or c:IsType(TYPE_SPSUMMON) or c:IsType(TYPE_FLIP) or c:IsType(TYPE_DUAL) or c:IsType(TYPE_SPIRIT))
end
function cm.tdfil2(c)
	return not (c:IsType(TYPE_UNION) or c:IsType(TYPE_TUNER) or c:IsType(TYPE_SPSUMMON) or c:IsType(TYPE_FLIP) or c:IsType(TYPE_DUAL) or c:IsType(TYPE_SPIRIT)) 
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(cm.tdfil1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local h=Duel.GetMatchingGroup(cm.tdfil2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tdfil1,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	local h=Duel.GetMatchingGroup(cm.tdfil2,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	Duel.SendtoDeck(h,nil,-2,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,1)
	e2:SetValue(cm.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_UNION) or c:IsType(TYPE_TUNER) or c:IsType(TYPE_SPSUMMON) or c:IsType(TYPE_FLIP) or c:IsType(TYPE_DUAL) or c:IsType(TYPE_SPIRIT)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not (re:GetHandler():IsType(TYPE_UNION) or re:GetHandler():IsType(TYPE_TUNER) or re:GetHandler():IsType(TYPE_SPSUMMON) or re:GetHandler():IsType(TYPE_FLIP) or re:GetHandler():IsType(TYPE_DUAL) or re:GetHandler():IsType(TYPE_SPIRIT))
end

--delete
function cm.cfilter2(c)
	return c:IsSetCard(0xe7b) and c:IsType(TYPE_MONSTER)
end
function cm.delcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil)
end
function cm.delfil(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.deltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.delfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(cm.delfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.delop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.delfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.SendtoDeck(sg,nil,-2,REASON_EFFECT)
	Duel.SetLP(tp,30303)
	Duel.SetLP(1-tp,30303)
	Duel.BreakEffect()
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end

--immune
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end