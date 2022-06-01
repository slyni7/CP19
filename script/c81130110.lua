--Tenkaigi's War
function c81130110.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81130110+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c81130110.cn)
	e1:SetTarget(c81130110.tg)
	e1:SetOperation(c81130110.op)
	c:RegisterEffect(e1)
end

--activation
function c81130110.cn(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c81130110.filter1(c,e,tp)
	return c:IsSetCard(0xcb0) and c:IsType(TYPE_MONSTER)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c81130110.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(c81130110.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81130110.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81130110.filter2(c)
	return c:IsSummonable(true,nil) and c:IsSetCard(0xcb0) and c:IsLevelAbove(5)
end
function c81130110.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) 
	and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_DOUBLE_TRIBUTE)
		e3:SetValue(c81130110.val)
		tc:RegisterEffect(e3)
		local og=Duel.GetMatchingGroup(c81130110.filter2,tp,LOCATION_HAND,0,nil)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and og:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81130110,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local oc=og:Select(tp,1,1,nil)
			Duel.Summon(tp,oc,true,nil)
		end
	end
end
function c81130110.val(e,c)
	return c:IsSetCard(0xcb0)
end
