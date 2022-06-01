--이로카와 루키
local m=112603153
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfil0,cm.mfil1,2,2)
	Xyz.AddProcedure(c,cm.mfilter,111,3,cm.ovfilter,aux.Stringid(m,2),3,cm.xyzop)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(kaos.xyzcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--negate
	local e30=Effect.CreateEffect(c)
	e30:SetCategory(CATEGORY_DISABLE)
	e30:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e30:SetCode(EVENT_CHAIN_SOLVING)
	e30:SetRange(LOCATION_MZONE)
	e30:SetCondition(cm.negcon)
	e30:SetOperation(cm.negop)
	c:RegisterEffect(e30)
end

cm.listed_names={112603118,112603143}

--xyz summon
function cm.mfil0(c,xyzc)
	return c:IsType(TYPE_MONSTER)
end
function cm.mfil1(g)
	return g:GetClassCount(Card.GetLevel)==g:GetCount()
end
function cm.mfilter(c,xyz,sumtype,tp)
	return c:IsRace(RACE_MACHINE,xyz,sumtype,tp) and c:IsAttribute(ATTRIBUTE_LIGHT,xyz,sumtype,tp)
end
function cm.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsSummonCode(lc,SUMMON_TYPE_XYZ,tp,112603143)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	return true
end

--to hand
function cm.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thfilter2(c)
	return c:IsCode(112603118) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local mg=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_DECK,0,nil)
		if #mg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end

--negate
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()==0 and rp~=tp 
		and (re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))) and Duel.IsChainDisablable(ev)
			and e:GetHandler():GetFlagEffect(m)<=0
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			Duel.BreakEffect()
			Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT)
		end
	end
end

