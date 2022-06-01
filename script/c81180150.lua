--KMS(메탈 블러드) U-47
--카드군 번호: 0xcb5
function c81180150.initial_effect(c)

	--바운스
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81180150,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81180150)
	e1:SetCondition(c81180150.cn1)
	e1:SetTarget(c81180150.tg1)
	e1:SetOperation(c81180150.op1)
	c:RegisterEffect(e1)
	
	--묘지회수
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81180150,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,81180151)
	e2:SetCondition(c81180150.cn2)
	e2:SetTarget(c81180150.tg2)
	e2:SetOperation(c81180150.op2)
	c:RegisterEffect(e2)
end

--바운스
function c81180150.cn1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
	and c:IsPreviousLocation(LOCATION_OVERLAY)
	and re:GetHandler():IsSetCard(0xcb5)
end
function c81180150.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_ONFIELD)
end
function c81180150.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

--묘지회수
function c81180150.cn2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c81180150.filter0(c)
	return c:IsFaceup() and c:IsAbleToGrave() and c:IsSetCard(0xcb5) and c:IsType(0x1)
end
function c81180150.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c81180150.filter0(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81180150.filter0,tp,LOCATION_REMOVED,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c81180150.filter0,tp,LOCATION_REMOVED,0,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c81180150.op2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_RETURN)
	end
end


