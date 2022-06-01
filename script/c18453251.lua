--EE(이터널 엘릭서) 블링크
function c18453251.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,18453251+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c18453251.cost1)
	e1:SetTarget(c18453251.target)
	e1:SetOperation(c18453251.activate)
	c:RegisterEffect(e1)
end
function c18453251.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,Card.IsCode,1,nil,18453234)
	end
	local g=Duel.SelectReleaseGroup(tp,Card.IsCode,1,1,nil,18453234)
	Duel.Release(g,REASON_COST)
end
function c18453251.tfilter11(c,h,p)
	return c:IsDestructable() and Duel.IsExistingTarget(c18453251.tfilter12,p,0,LOCATION_ONFIELD,1,c,h)
end
function c18453251.tfilter12(c,h)
	return c~=h and c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c18453251.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return false
	end
	if chk==0 then
		return Duel.IsExistingTarget(c18453251.tfilter11,tp,0,LOCATION_MZONE,1,c,c,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectTarget(tp,c18453251.tfilter11,tp,0,LOCATION_MZONE,1,1,c,c,tp)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,c18453251.tfilter12,tp,0,LOCATION_ONFIELD,1,1,tc,c)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c18453251.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end