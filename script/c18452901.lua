--트비넷호-기도섬
function c18452901.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCondition(c18452901.condition)
	e1:SetTarget(c18452901.target)
	e1:SetOperation(c18452901.activate)
	c:RegisterEffect(e1)
end
function c18452901.cfilter(c)
	return c:GetSequence()<5
end
function c18452901.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c18452901.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c18452901.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=0
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3 then
		atk=1500
	end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18452908,0,0x12da,atk,atk,1,RACE_WARRIOR,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c18452901.filter(c,token)
	if YGOPRO_VERSION=="Percy/EDO" then
		if IREDO_COMES_TRUE then
			return c:IsSetCard(0x12da) and c:IsLinkSummonable(nil,token)
		else
			return c:IsSetCard(0x12da) and c:IsLinkSummonable(token)
		end
	else
		return c:IsSetCard(0x12da) and c:IsLinkSummonable(nil,token)
	end
end
function c18452901.activate(e,tp,eg,ep,ev,re,r,rp)
	local atk=0
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3 then
		atk=1500
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,18452908,0,0x12da,atk,atk,1,RACE_WARRIOR,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,18452908)
	if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e2)
		if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_TRAP)>=3 then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_SET_ATTACK)
			e3:SetValue(1500)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_SET_DEFENSE)
			token:RegisterEffect(e4)
		end
	end
	Duel.SpecialSummonComplete()
	local g=Duel.GetMatchingGroup(c18452901.filter,tp,LOCATION_EXTRA,0,nil,token)
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()&(PHASE_MAIN1+PHASE_MAIN2)>0
		and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(18452901,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if YGOPRO_VERSION=="Percy/EDO" then
			if IREDO_COMES_TRUE then
				Duel.LinkSummon(tp,tc,nil,token)
			else
				Duel.LinkSummon(tp,tc,token)
			end
		else
			Duel.LinkSummon(tp,tc,nil,token)
		end
	end
end