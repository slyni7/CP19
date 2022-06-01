--월토-이글 슈터
--카드군 번호: 0xca7
function c81060110.initial_effect(c)

	--발동
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c81060110.tg1)
	e1:SetOperation(c81060110.op1)
	c:RegisterEffect(e1)
	
	--타점
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81060110,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c81060110.tg2)
	e2:SetOperation(c81060110.op2)
	c:RegisterEffect(e2)
end

--발동
function c81060110.filter0(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xca7)
	and Duel.IsExistingMatchingCard(c81060110.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c)
end
function c81060110.filter1(c,tc)
	return c:IsSetCard(0xca9) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc)
end
function c81060110.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c81060110.filter0(chkc,tp)
	end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c81060110.filter0,tp,LOCATION_MZONE,0,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c81060110.filter0,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c81060110.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c81060110.filter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tc)
	local eq=g:GetFirst()
	if eq then
		Duel.Equip(tp,eq,tc,true)
	end
end

--타점
function c81060110.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca7) and c:GetEquipCount()>0
end
function c81060110.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81060110.cfilter,tp,LOCATION_MZONE,0,1,nil)
	end
end
function c81060110.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c81060110.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local ct=tc:GetEquipCount()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end


