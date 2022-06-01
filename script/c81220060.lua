--율자인자 공간율령
function c81220060.initial_effect(c)

	--activation
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81220060+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c81220060.tg1)
	e1:SetOperation(c81220060.op1)
	c:RegisterEffect(e1)
	
	--status
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81220060,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c81220060.cn2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81220060.tg2)
	e2:SetOperation(c81220060.op2)
	c:RegisterEffect(e2)
end

--activation
function c81220060.filter1(c,e,tp,ft)
	return c:IsSetCard(0xcbb) and c:GetLevel()==4
	and ( c:IsAbleToDeck() or ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) )
end
function c81220060.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81220060.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c81220060.op1(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c81220060.filter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	if tc then
		if ft>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and ( not tc:IsAbleToDeck() or Duel.SelectYesNo(tp,aux.Stringid(81220060,0)) ) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
		end
	end
end

--status
function c81220060.cn2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c81220060.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0xcbb)
end
function c81220060.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c81220060.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81220060.filter2,tp,LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c81220060.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c81220060.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(tc:GetBaseDefense()*2)
		tc:RegisterEffect(e2)
	end
end


