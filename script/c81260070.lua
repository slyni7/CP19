--펑크랙 레가시
--카드군 번호: 0xcbf
function c81260070.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81260070)
	e1:SetTarget(c81260070.tg1)
	e1:SetOperation(c81260070.op1)
	c:RegisterEffect(e1)
	
	--특수소환
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81260070,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,81260070)
	e2:SetCondition(c81260070.cn2)
	e2:SetTarget(c81260070.tg2)
	e2:SetOperation(c81260070.op2)
	c:RegisterEffect(e2)
end

--발동
function c81260070.filter0(c)
	return c:IsFaceup() and c:IsSetCard(0xcbf)
end
function c81260070.filter1(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcbf) and c:GetLevel()>0 and c:IsType(TYPE_MONSTER)
end
function c81260070.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81260070.filter0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81260070.filter0,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c81260070.filter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81260070.filter0,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c81260070.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81260070.filter1,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if g and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:IsLocation(LOCATION_GRAVE)
	and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local lv=g:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end

--특수소환
function c81260070.cn2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetReason(),REASON_EFFECT)==REASON_EFFECT and re:GetOwner():IsSetCard(0xcbf)
end
function c81260070.sfilter(c,e,tp)
	return c:IsSetCard(0xcbf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c81260070.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81260070.sfilter(chkc,e,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c81260070.sfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c81260070.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c81260070.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end


