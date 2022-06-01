--중장 토끼 해킹
--카드군 번호: 0xcbd
function c81240070.initial_effect(c)

	--컨트롤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81240070,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81240070+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81240070.co1)
	e1:SetTarget(c81240070.tg1)
	e1:SetOperation(c81240070.op1)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(81240070,ACTIVITY_SPSUMMON,c81240070.cfilter)
	
	--겟 라이드
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81240070,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81240070.tg2)
	e2:SetOperation(c81240070.op2)
	c:RegisterEffect(e2)
end

--컨트롤
function c81240070.cfilter(c)
	return c:IsSetCard(0xcbd)
end
function c81240070.filter0(c)
	return c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsSetCard(0xcbd) 
end
function c81240070.co1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81240070.filter0,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.GetCustomActivityCount(81240070,tp,ACTIVITY_SPSUMMON)==0
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81240070.filter0,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTarget(c81240070.lm1)
	e1:SetTargetRange(1,0)
	e1:SetLabelObject(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c81240070.lm1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xcbd)
end
function c81240070.filter1(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged()
end
function c81240070.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81240070.filter1,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c81240070.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c81240070.filter1,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(RACE_PSYCHO)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end

--겟 라이드
function c81240070.ufilter0(c,tp)
	return c:IsType(TYPE_UNION) and c:IsSetCard(0xcbd)
	and Duel.IsExistingMatchingCard(c81240070.ufilter1,tp,LOCATION_MZONE,0,1,nil,c)
end
function c81240070.ufilter1(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c) and aux.CheckUnionEquip(eqc,c)
end
function c81240070.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81240070.ufilter0(chkc,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>(e:GetHandler():IsLocation(LOCATION_SZONE) and 0 or 1)
		and Duel.IsExistingTarget(c81240070.ufilter0,tp,LOCATION_GRAVE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c81240070.ufilter0,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c81240070.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,c81240070.ufilter1,tp,LOCATION_MZONE,0,1,1,nil,tc)
		local tc2=g:GetFirst()
		if tc2 and aux.CheckUnionEquip(tc,tc2) and Duel.Equip(tp,tc,tc2) then
			aux.SetUnionState(tc)
		end
	end
end


