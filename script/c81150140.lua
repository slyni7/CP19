--멜로디블 레코즈 서곡
--카드군 번호: 0xcb2
function c81150140.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81150140+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81150140.tg1)
	e1:SetOperation(c81150140.op1)
	c:RegisterEffect(e1)
	
	--특수 소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81150140,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c81150140.cn2)
	e2:SetTarget(c81150140.tg2)
	e2:SetOperation(c81150140.op2)
	c:RegisterEffect(e2)
end

--발동
function c81150140.tfil0(c)
	return c:IsSetCard(0xcb2) and c:IsType(TYPE_TRAP)
	and ( c:IsAbleToGrave() or c:IsSSetable(true) )
end
function c81150140.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81150140.tfil0,tp,0x01+0x10,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x01+0x10)
end
function c81150140.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local sel=0
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<0 then sel=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c81150140.tfil0,tp,0x01+0x10,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc:IsLocation(LOCATION_GRAVE) 
	and tc and ( sel==1 or Duel.SelectYesNo(tp,aux.Stringid(81150140,2)) ) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	else
		Duel.SSet(tp,tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end

--특수 소환
function c81150140.tfil1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcb2) and c:IsSummonType(SUMMON_TYPE_LINK) and c:GetSummonPlayer()==tp
end
function c81150140.cn2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c81150140.tfil1,1,nil,tp)
end
function c81150140.spfil0(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c81150140.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81150140.spfil0(chkc,e,tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81150140.spfil0,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81150140.spfil0,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81150140.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetValue(LOCATION_DECKBOT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
