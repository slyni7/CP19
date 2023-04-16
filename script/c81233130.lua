--TF 시나토
--카드군 번호: 0xc8f
local m=81233130
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,3,cm.lchk)
	
	--유발 효과
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.cn1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.va2)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	
	--유발즉시 효과
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(0x04)
	e3:SetCountLimit(1,m+1)
	e3:SetCondition(cm.cn3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	c:RegisterEffect(e3)
end

function cm.lchk(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xc8f)
end

--효과를 무효로 한다
function cm.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,0x0c,1,nil)
	end
	if e:GetLabel()==1 then Duel.SetChainLimit(cm.chainlimit) end
end
function cm.chainlimit(e,rp,tp)
	return tp==rp
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0x0c,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
function cm.vfilter0(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(8)
end
function cm.va2(e,c)
	local g=c:GetMaterial()
	if g:IsExists(cm.vfilter0,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end

--특수 소환
function cm.cn3(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.spfilter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_WINDBEAST) and c:GetLevel()>0
	and (c:IsLocation(0x10) or c:IsFaceup())
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToExtra()
		and Duel.GetLocationCount(tp,0x04)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter0),tp,0x10+0x20,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x10+0x20)
end
function cm.synfilter0(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSynchroSummonable(nil)
end
function cm.linfilter0(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsLinkSummonable(nil)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local ft=Duel.GetLocationCount(tp,0x04)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter0),tp,0x10+0x20,0,nil,e,tp)
	if ft<=0 or #g==0 then
		return
	end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,ft,nil)
	local tc=sg:GetFirst()
	while tc do
		local res=Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.AdjustAll()
	local b1=Duel.IsExistingMatchingCard(cm.synfilter0,tp,0x40,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.linfilter0,tp,0x40,0,1,nil)
	if res~=0 and (b1 or b2) and Duel.IsPlayerCanSpecialSummonCount(tp,2) then
		local off=1
		local ops,opval={},{}
		if b1 then
			ops[off]=aux.Stringid(m,3)
			opval[off]=0
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(m,4)
			opval[off]=1
			off=off+1
		end
		ops[off]=aux.Stringid(m,5)
		opval[off]=2
		local op=Duel.SelectOption(tp,table.unpack(ops))+1
		local sel=opval[op]
		if sel==0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,cm.synfilter0,tp,0x40,0,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil)
		elseif sel==1 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,cm.linfilter0,tp,0x40,0,1,1,nil)
			Duel.LinkSummon(tp,sg:GetFirst(),nil)
		end
	end
end
