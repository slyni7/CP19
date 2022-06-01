--USS(이글 유니온) 헬레나
--카드군 번호: 0xcb4
function c81170150.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(c81170150.mfilter),2,2)
	
	--공수감소
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c81170150.cn1)
	e1:SetOperation(c81170150.op1)
	c:RegisterEffect(e1)
	
	--바운스
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c81170150.co2)
	e2:SetTarget(c81170150.tg2)
	e2:SetOperation(c81170150.op2)
	c:RegisterEffect(e2)
end

--소재
function c81170150.mfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_MACHINE)
end

--공수감소
function c81170150.cn1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=a:GetBattleTarget()
	return a:IsControler(tp) and a:IsRace(RACE_MACHINE)
	and d and d:IsFaceup() and not d:IsControler(tp)
end
function c81170150.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttacker():GetBattleTarget()
	if d:IsRelateToBattle() and d:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		d:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		d:RegisterEffect(e2)
	end
end

--바운스
function c81170150.filter(c)
	return c:IsAbleToGraveAsCost() and c:IsSetCard(0xcb4) and c:IsType(TYPE_MONSTER)
	and ( c:IsFaceup() or c:IsLocation(LOCATION_HAND) )
end
function c81170150.co2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81170150.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81170150.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81170150.vfilter(c)
	return c:IsAbleToDeck() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c81170150.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and c81170150.vfilter(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81170150.vfilter,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c81170150.vfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c81170150.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
