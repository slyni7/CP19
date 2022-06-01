--IJN(사쿠라 엠파이어) 이부키
--카드군 번호: 0xcb6
function c81190160.initial_effect(c)

	c:EnableReviveLimit()
	
	--특수소환
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c81190160.cn1)
	e2:SetOperation(c81190160.op1)
	c:RegisterEffect(e2)
	
	--파괴
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81190160)
	e3:SetCost(c81190160.co3)
	e3:SetTarget(c81190160.tg3)
	e3:SetOperation(c81190160.op3)
	c:RegisterEffect(e3)
	
	--서치
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(81190160,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1,81190161)
	e4:SetCondition(c81190160.cn4)
	e4:SetTarget(c81190160.tg4)
	e4:SetOperation(c81190160.op4)
	c:RegisterEffect(e4)
end

--특수소환
function c81190160.mfilter(c)
	return c:IsSetCard(0xcb6) and c:IsType(TYPE_FUSION)
end
function c81190160.cn1(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),c81190160.mfilter,1,nil)
end
function c81190160.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c81190160.mfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end

--파괴
function c81190160.filter1(c)
	return c:IsAbleToGraveAsCost() and c:IsLevelAbove(5)
end
function c81190160.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81190160.filter1,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81190160.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c81190160.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return true
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c81190160.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--서치
function c81190160.cn4(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION and e:GetHandler():GetReasonCard():IsSetCard(0xcb6)
end
function c81190160.filter2(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPIRIT) and ( c:IsLocation(LOCATION_DECK) or c:IsFaceup() )
end
function c81190160.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function c81190160.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c81190160.filter2,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
