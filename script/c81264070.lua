--베노퀄리아 미즈치
--카드군 번호: 0xc94

function c81264070.initial_effect(c)

	--의식 레벨
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_RITUAL_LEVEL)
	e1:SetValue(c81264070.val)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e2:SetCountLimit(1,81264072)
	e2:SetTarget(c81264070.tg2)
	e2:SetOperation(c81264070.op2)
	c:RegisterEffect(e2)
end

--의식 레벨
function c81264070.val(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xc94) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end

--특수 소환
function c81264070.filter0(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:GetBaseAttack()>0
end
function c81264070.filter1(c)
	return c:IsAbleToGrave() and c:IsRace(RACE_REPTILE)
end
function c81264070.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and c81264070.filter0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81264070.filter0,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(c81264070.filter1,tp,LOCATION_HAND,0,1,e:GetHandler())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINT_FACEUP)
	local g=Duel.SelectTarget(tp,c81264070.filter0,tp,LOCATION_MZONE,LOCATION_MZONE,0,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c81264070.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c81264070.filter1,tp,LOCATION_HAND,0,1,1,c)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2,true)
end


