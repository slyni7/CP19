--H. Enchantment: Stella Melody
function c99970034.initial_effect(c)

	--드로우
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c99970034.cost)
	e1:SetTarget(c99970034.target)
	e1:SetOperation(c99970034.activate)
	c:RegisterEffect(e1)
	
	--덤핑
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,99970034)
	e2:SetCondition(c99970034.tgcon)
	e2:SetTarget(c99970034.tgtg)
	e2:SetOperation(c99970034.tgop)
	c:RegisterEffect(e2)
	
end

--드로우
function c99970034.costfilter(c)
	return c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c99970034.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c99970034.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c99970034.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c99970034.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c99970034.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

--덤핑
function c99970034.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c99970034.tgfilter(c)
	return c:IsSetCard(0xd32) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c99970034.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c99970034.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c99970034.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end


