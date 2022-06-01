--베노퀄리아 아페독스
--카드군 번호: 0xc94

function c81264020.initial_effect(c)

	c:EnableReviveLimit()
	
	--묘지 회수
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,81264020)
	e1:SetCondition(c81264020.cn1)
	e1:SetTarget(c81264020.tg1)
	e1:SetOperation(c81264020.op1)
	c:RegisterEffect(e1)
	
	--파괴
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,81264021)
	e2:SetTarget(c81264020.tg2)
	e2:SetOperation(c81264020.op2)
	c:RegisterEffect(e2)
end

--묘지 회수
function c81264020.cn1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
	and e:GetHandler():IsReason(REASON_EFFECT)
end
function c81264020.filter1(c)
	return c:IsAbleToHand() and c:IsSetCard(0xc94)
end
function c81264020.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c81264020.filter1(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81264020.filter1,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c81264020.filter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c81264020.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--파괴
function c81264020.filter2(c)
	return c:IsFaceup() and c:GetAttack()==0
end
function c81264020.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and c81264020.filter2(chkc)
	end
	if chk==0 then
		return Duel.IsExistingTarget(c81264020.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	local tc=1
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then tc=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c81264020.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#g)
end
function c81264020.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #sg>0 and Duel.Destroy(sg,REASON_EFFECT)~=0 then
		Duel.Draw(tp,#sg,REASON_EFFECT)
	end
end
