--LMo.90 악마,「아이자나」[G]
local m=112603390
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Link summon
	Link.AddProcedure(c,nil,1,1)
	--negate
	local e30=Effect.CreateEffect(c)
	e30:SetCategory(CATEGORY_DISABLE)
	e30:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e30:SetCode(EVENT_CHAIN_SOLVING)
	e30:SetRange(LOCATION_MZONE)
	e30:SetCondition(cm.negcon)
	e30:SetOperation(cm.negop)
	c:RegisterEffect(e30)
	--link
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(kaos.onecost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end

cm.messier_number=90

--negate
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp 
		and (re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))) and Duel.IsChainDisablable(ev)
			and e:GetHandler():GetFlagEffect(m)<=0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			Duel.Destroy(rc,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		end
	end
end

--link
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if YGOPRO_VERSION=="Percy/EDO" then
			if IREDO_COMES_TRUE then
				return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler())
			else
				return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,e:GetHandler())
			end
		else
			return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler())
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsControler(1-tp) then return end
	local g
	if YGOPRO_VERSION=="Percy/EDO" then
		if IREDO_COMES_TRUE then
			g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
		else
			g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,c)
		end
	else
		g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if YGOPRO_VERSION=="Percy/EDO" then
			if IREDO_COMES_TRUE then
				Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
			else
				Duel.LinkSummon(tp,sg:GetFirst(),c)
			end
		else
			Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
		end
	end
end