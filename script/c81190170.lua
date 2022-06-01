--IJN(사쿠라 엠파이어) 나가토
--카드군 번호: 0xcb6
function c81190170.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2,4,c81190170.mfilter1)
	
	--파괴내성
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c81190170.tg1)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	
	--공격력 상승
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c81190170.tg2)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	
	--프리체인
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81190170)
	e3:SetCost(c81190170.co3)
	e3:SetTarget(c81190170.tg3)
	e3:SetOperation(c81190170.op3)
	c:RegisterEffect(e3)
end

--링크소재
function c81190170.mfilter1(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0xcb6)
end

--파괴내성 & 공격력 상승
function c81190170.tg1(e,c)
	return c==e:GetHandler()
		or c:IsFaceup() and e:GetHandler():GetLinkedGroup():IsContains(c)
end

function c81190170.tg2(e,c)
	return c:IsFaceup() and c:IsSetCard(0xcb6) and not c:IsCode(81190170)
end

--프리체인
function c81190170.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
	end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c81190170.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*300)
end
function c81190170.op3(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(tg,REASON_EFFECT)
	if ct then
		Duel.Damage(1-tp,ct*300,REASON_EFFECT)
	end
end


