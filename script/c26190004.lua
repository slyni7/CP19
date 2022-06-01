--가 장조의 선율
function c26190004.initial_effect(c)
	aux.AddCodeList(c,26190001)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26190004+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c26190004.con1)
	e1:SetTarget(c26190004.tar1)
	e1:SetOperation(c26190004.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetCountLimit(1,26190005)
	e2:SetCondition(c26190004.con2)
	e2:SetCost(c26190004.cost2)
	e2:SetTarget(c26190004.tar2)
	e2:SetOperation(c26190004.op2)
	c:RegisterEffect(e2)
end
function c26190004.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c26190004.tfil11(c,e,tp,g,sg)
	sg:AddCard(c)
	local res=sg:IsExists(c26190004.tfil12,1,nil,e,tp,sg)
		or g:IsExists(c26190004.tfil11,1,sg,e,tp,g,sg)
	sg:RemoveCard(c)
	return res
end
function c26190004.tfil12(c,e,tp,sg)
	if not c:IsCode(26190001) or c:IsType(TYPE_RITUAL) then
		return false
	end
	if sg:GetCount()<2 then
		return
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsLocation(LOCATION_MZONE) then
		ft=ft+1
	end
	return ft>0 or sg:IsExists(c26190004.tfil13,1,nil,tp)
end
function c26190004.tfil13(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c26190004.tfil14(c,e)
	if c:IsImmuneToEffect(e) or (c:IsOnField() and not c:IsReleasable()) then
		return false
	end
	return c:GetRank()>0 or c:GetLink()>0 or c:IsHasEffect(26190003)
end
function c26190004.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local v1=Duel.GetTurnPlayer()==tp and Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)<1
	local g=Duel.GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(c26190004.tfil14,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,e)
	g:Merge(exg)
	local sg=Group.CreateGroup()
	local v2=Duel.IsPlayerCanSpecialSummonMonster(tp,26190001,0,0xa1,-2,400,4,RACE_FAIRY,ATTRIBUTE_LIGHT)
		and g:IsExists(c26190004.tfil11,1,nil,e,tp,g,sg)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then
		return v1 or v2
	end
	local op=0
	if v1 and v2 then
		op=Duel.SelectOption(tp,aux.Stringid(26190004,0),aux.Stringid(26190004,1))
	elseif v1 then
		op=0
	else
		op=1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c26190004.ofil1(c,e,tp)
	return c:IsCode(26190001) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function c26190004.oval1(c)
	if c:GetLevel()>0 then
		return c:GetLevel()
	elseif c:GetRank()>0 then
		return c:GetRank()
	elseif c:GetLink()>0 then
		return c:GetLink()
	end
	return 0
end
function c26190004.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,26190001))
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	else
		local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local mg=Duel.GetRitualMaterial(tp)
		local exg=Duel.GetMatchingGroup(c26190004.tfil14,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,e)
		mg:Merge(exg)
		local rg=Group.CreateGroup()
		if not mg:IsExists(c26190004.tfil11,1,nil,e,tp,mg,rg)
			or not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) then
			return
		end
		while true do
			local mi=1
			if rg:IsExists(c26190004.tfil12,1,nil,e,tp,rg) then
				mi=0
			end
			local cg=mg:Filter(c26190004.tfil11,rg,e,tp,mg,rg)
			if #cg<1 then
				break
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local ag=mg:Select(tp,mi,1,rg)
			local ac=ag:GetFirst()
			if not ac then
				break
			end
			rg:Merge(ag)
		end
		local slv=0
		local lv=0
		local lc=rg:GetFirst()
		while lc do
			if lc:GetLevel()>0 then
				lv=lc:GetLevel()
			elseif lc:GetRank()>0 then
				lv=lc:GetRank()
			elseif lc:GetLink()>0 then
				lv=lc:GetLink()
			elseif lc:IsHasEffect(26190003) then
				lv=3
			end
			slv=slv+lv
			lc=rg:GetNext()
		end
		local tg,lv=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil):GetMaxGroup(c26190004.oval1)
		slv=slv+lv
		Duel.ReleaseRitualMaterial(rg)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=rg:FilterSelect(tp,c26190004.ofil1,1,1,nil,e,tp)
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(rg)
			Duel.SpecialSummonStep(sc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(slv)
			sc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
			sc:CompleteProcedure()
		end
	end
end
function c26190004.nfil2(c)
	return c:IsCode(26190001) and c:IsFaceup()
end
function c26190004.con2(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c26190004.nfil2,tp,LOCATION_MZONE,0,1,nil)
end
function c26190004.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return c:IsAbleToDeckAsCost()
	end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c26190004.tfil2(c)
	return c:IsCode(26190001) and c:IsAbleToHand()
end
function c26190004.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c26190004.tfil2,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26190004.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c26190004.tfil2,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end