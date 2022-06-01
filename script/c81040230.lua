--염옥-심연의 별
--카드군 번호: 0xca4
function c81040230.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c81040230.mfilter0,5,3,c81040230.mfilter1,aux.Stringid(81040230,0),3,c81040230.xyzop)
	
	--명칭
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(81040000)
	c:RegisterEffect(e1)
	
	--덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c81040230.cn2)
	e2:SetTarget(c81040230.tg2)
	e2:SetOperation(c81040230.op2)
	c:RegisterEffect(e2)
	
	--바운스
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c81040230.cn3)
	e3:SetTarget(c81040230.tg3)
	e3:SetOperation(c81040230.op3)
	c:RegisterEffect(e3)
end

--소재
function c81040230.mfilter0(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c81040230.mfilter1(c)
	return c:IsFaceup() and c:IsCode(81040000)
end
function c81040230.xyzop(e,tp,chk)
	if chk==0 then
		return Duel.GetFlagEffect(tp,81040230)==0
	end
	Duel.RegisterFlagEffect(tp,81040230,RESET_PHASE+PHASE_END,0,1)
end

--덤핑
function c81040230.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c81040230.filter0(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xca4)
end
function c81040230.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81040230.filter0,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,800)
end
function c81040230.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c81040230.filter0,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Damage(tp,800,REASON_EFFECT)
	end
end

--바운스
function c81040230.cn3(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and bit.band(r,REASON_EFFECT)~=0 and re:GetHandler():IsSetCard(0xca4)
end
function c81040230.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsAbleToDeck()
	end
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c81040230.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end


