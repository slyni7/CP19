--중장 토끼 리미터 브레이크
--카드군 번호: 0xcbd
function c81240080.initial_effect(c)

	--제거
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81240080,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_EQUIP)
	e1:SetCountLimit(1,81240079)
	e1:SetTarget(c81240080.tg1)
	e1:SetOperation(c81240080.op1)
	c:RegisterEffect(e1)
	
	--장착
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81240080,2))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81240080)
	e2:SetCost(c81240080.co2)
	e2:SetTarget(c81240080.tg2)
	e2:SetOperation(c81240080.op2)
	c:RegisterEffect(e2)
	--장착대상변경
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(81240080,3))
	e3:SetTarget(c81240080.tg3)
	e3:SetOperation(c81240080.op3)
	c:RegisterEffect(e3)
end

--제거
function c81240080.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_ONFIELD)
end
function c81240080.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end

--장착관련
function c81240080.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function c81240080.tfilter0(c,e,tp,chk)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
	and c:IsCanBeEffectTarget(e) 
	and ( chk or Duel.IsExistingMatchingCard(c81240080.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c) )
end
function c81240080.tfilter1(c,ec)
	return c:IsType(TYPE_UNION) and c:IsSetCard(0xcbd) and c:CheckEquipTarget(ec) and aux.CheckUnionEquip(c,ec)
	and not c:IsForbidden()
end
function c81240080.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c81240080.tfilter0(chkc,e,tp,true)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c81240080.tfilter0,tp,LOCATION_MZONE,0,1,nil,e,tp,false)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81240080.tfilter0,tp,LOCATION_MZONE,0,1,1,nil,e,tp,false)
end
function c81240080.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=Duel.SelectMatchingCard(tp,c81240080.tfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tc)
		local ec=sg:GetFirst()
		if ec and aux.CheckUnionEquip(ec,tc) and Duel.Equip(tp,ec,tc) then
			aux.SetUnionState(ec)
		end
	end
end

function c81240080.cfilter0(c,tp)
	return c:IsType(TYPE_UNION) and c:IsSetCard(0xcbd)
	and Duel.IsExistingMatchingCard(c81240080.cfilter1,tp,LOCATION_MZONE,0,1,nil,c)
end
function c81240080.cfilter1(c,ec)
	return c:IsFaceup() and ec:CheckEquipTarget(c) and aux.CheckUnionEquip(ec,c)
end
function c81240080.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c81240080.cfilter0(chkc,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>(e:GetHandler():IsLocation(LOCATION_SZONE) and 0 or 1)
		and Duel.IsExistingTarget(c81240080.cfilter0,tp,LOCATION_SZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c81240080.cfilter0,tp,LOCATION_SZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_FIELD,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c81240080.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectMatchingCard(tp,c81240080.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,tc)
		local tc2=g:GetFirst()
		if tc2 and aux.CheckUnionEquip(tc,tc2) and Duel.Equip(tp,tc,tc2) then
			aux.SetUnionState(tc)
		end
	end
end

