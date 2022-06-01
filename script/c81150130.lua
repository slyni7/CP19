--멜로디블 돌체
--카드군 번호: 0xcb2
function c81150130.initial_effect(c)

	--특수소환 제약
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_DECK)
	c:RegisterEffect(e1)
	
	--특수소환
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,81150130)
	e2:SetCondition(c81150130.cn2)
	c:RegisterEffect(e2)
	
	--샐비지
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(81150130,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c81150130.tg3)
	e3:SetOperation(c81150130.op3)
	c:RegisterEffect(e3)
end

--특수소환
function c81150130.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and not c:IsCode(81150130)
end
function c81150130.cn2(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c81150130.cfilter,tp,LOCATION_MZONE,0,1,nil)
end

--샐비지
function c81150130.filter0(c)
	return c:IsFaceup() and c:IsAbleToHand() and c:IsSetCard(0xcb2)
end
function c81150130.filter1(c)
	return c:IsAbleToDeck() and c:IsSetCard(0xcb2) and c:IsType(TYPE_LINK)
end
function c81150130.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsControler(tp) and chkc:IsOnField() and c81150130.filter0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81150130.filter0,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingMatchingCard(c81150130.filter1,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c81150130.filter0,tp,LOCATION_ONFIELD,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function c81150130.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,c81150130.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
		end
	end
end


