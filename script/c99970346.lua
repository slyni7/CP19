--Orcatia Rasha
local m=99970346
local cm=_G["c"..m]
function cm.initial_effect(c)
	
	--모듈 소환
	RevLim(c)
	aux.AddModuleProcedure(c,cm.mod1,aux.FilterBoolFunction(Card.IsModuleSetCard,0xe10),2,99,nil)

	--장착
	local e1=MakeEff(c,"Qo","M")
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	WriteEff(e1,1,"CTO")
	c:RegisterEffect(e1)
	
	--효과 대상 내성 부여
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	e2:SetTarget(cm.tgtg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	
	--특수 소환
	local e3=MakeEff(c,"STo")
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(spinel.delay+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	WriteEff(e3,3,"NTO")
	c:RegisterEffect(e3)
	
end

--모듈 소환
function cm.mod1(c)
	return c:IsModuleRace(RACE_PLANT) and not c:IsCode(m)
end

--장착
function cm.cfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToDeckAsCost()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,2,2,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.eqfil(c,ec)
	return c:IsType(TYPE_UNION) and c:CheckEquipTarget(ec) and aux.CheckUnionEquip(c,ec)
end
function cm.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.eqfil,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,cm.eqfil,tp,LOCATION_DECK,0,1,1,nil,c)
	local ec=g:GetFirst()
	if ec and aux.CheckUnionEquip(ec,c) and Duel.Equip(tp,ec,c) then
		aux.SetUnionState(ec)
	end
end

--효과 대상 내성 부여
function cm.tgtg(e,c)
	return e:GetHandler():GetEquipGroup():IsContains(c)
end

--특수 소환
function cm.filter(c,e,tp)
	return c:IsType(TYPE_UNION) and c:IsSetCard(0xe10) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tar3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft>0 and (g:GetCount()>0 or (g:GetCount()>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if g:GetCount()>ft then g=g:Select(tp,ft,ft,nil) end
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
