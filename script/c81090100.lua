--dokuga

function c81090100.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81090100)
	e1:SetCost(c81090100.dsco)
	e1:SetTarget(c81090100.dstg)
	e1:SetOperation(c81090100.dsop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81090100,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,81090101)
	e2:SetTarget(c81090100.grtg)
	e2:SetOperation(c81090100.grop)
	c:RegisterEffect(e2)
	
end

function c81090100.dscofilter(c)
	return ( c:IsLocation(LOCATION_HAND) or c:IsFaceup() ) and c:IsSetCard(0xcac) and c:IsReleasable()
end
function c81090100.dsco(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=(LOCATION_HAND+LOCATION_MZONE)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81090100.dscofilter,tp,loc,0,1,nil)
	end
	local g=Duel.GetMatchingGroup(c81090100.dscofilter,tp,loc,0,nil)
	local sg=g:Select(tp,1,2,nil)
	e:SetLabel(sg:GetCount()+1)
	Duel.Release(sg,REASON_COST)
end

function c81090100.dstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTORY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,e:GetLabel(),nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end

function c81090100.dsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
end

function c81090100.grtgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xcac) and c:IsType(TYPE_MONSTER)
end
function c81090100.grtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81090100.grtgfilter,tp,LOCATION_DECK,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end

function c81090100.grop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c81090100.grtgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
