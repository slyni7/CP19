--궤룡 오페라토
-- 0xc95
function c81263080.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddModuleProcedure(c,c81263080.mfilter,nil,1,5,nil)
	
	--무효
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c81263080.cn1)
	e1:SetTarget(c81263080.tg1)
	e1:SetOperation(c81263080.op1)
	c:RegisterEffect(e1)
	
	--회수 금지
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_REMOVED))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e3)
	
	--회수
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,81263081)
	e4:SetCondition(c81263080.cn4)
	e4:SetTarget(c81263080.tg4)
	e4:SetOperation(c81263080.op4)
	c:RegisterEffect(e4)
end

--모듈 소환
function c81263080.mfilter(c)
	return c:IsSetCard(0xc95) and c:IsType(TYPE_MODULE) and not c:IsAttribute(ATTRIBUTE_WATER)
end

--무효
function c81263080.cn1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c81263080.tfilter(c)
	return c:IsType(TYPE_EQUIP) and ( c:IsFaceup() or c:IsLocation(LOCATION_HAND) )
end
function c81263080.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil)
		and Duel.IsExistingMatchingCard(c81263080.tfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_SZONE)
end
function c81263080.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c81263080.tfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,1,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
			local c=e:GetHandler()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e1:SetTarget(c81263080.otg1)
			e1:SetLabelObject(tc)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetCondition(c81263080.ocn2)
			e2:SetOperation(c81263080.oop2)
			e2:SetLabelObject(tc)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function c81263080.otg1(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c81263080.ocn2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c81263080.oop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end

--회수
function c81263080.cn4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_MODULE) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c81263080.filter0(c)
	return ( c:IsRace(RACE_WYRM) or c:GetType()&TYPE_SPELL+TYPE_EQUIP==TYPE_SPELL+TYPE_EQUIP )
	and c:IsAbleToHand()
end
function c81263080.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81263080.filter0,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c81263080.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c81263080.filter0,tp,LOCATION_GRAVE,0,1,1,c)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


