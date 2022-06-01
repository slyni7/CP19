--SERENADE@SPELL
local m=99000358
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,99000355)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,m+1000)
	e2:SetCondition(cm.condition)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
function cm.spell_filter(c)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND))
		and c:IsSetCard(0xc13) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.CheckRemoveOverlayCard(tp,1,0,3,REASON_COST)
	local b2=Duel.IsExistingMatchingCard(cm.spell_filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
	if chk==0 then return b1 or b2 end
	if b1~=false and (not b2~=false or Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))==0) then
		Duel.RemoveOverlayCard(tp,1,0,3,3,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.spell_filter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,exc)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,exc)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.filter1(c,e,tp)
	local lv=c:GetLevel()
	local rk=c:GetRank()
	return ((c:IsSetCard(0xc22) and rk>0 and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1))
		or (c:IsCode(99000355) and lv>0 and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,lv+1)))
		and c:IsFaceup() and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.filter2(c,e,tp)
	local lv=c:GetLevel()
	local rk=c:GetRank()
	return ((rk>0 and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk+1))
		or (lv>0 and Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,lv+1)))
		and c:IsFaceup() and c:IsControlerCanBeChanged() and aux.MustMaterialCheck(c,1-tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.filter3(c,e,tp,mc,rk)
	return c:IsRank(rk) and c:IsSetCard(0xc22) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if Duel.GetTurnPlayer()==tp then
		if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter1(chkc,e,tp) end
		if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	else
		if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter2(chkc,e,tp) end
		if chk==0 then return Duel.IsExistingTarget(cm.filter2,tp,0,LOCATION_MZONE,1,nil,e,tp) end
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,cm.filter2,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetTurnPlayer()~=tp then
		if not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
		if Duel.GetControl(tc,tp)==0 then return end
		Duel.BreakEffect()
	end
	if not aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=nil
	if tc:GetRank()>0 then
		g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank()+1)
	else
		g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetLevel()+1)
	end
	local sc=g:GetFirst()
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end