--레고 스타
function c76859215.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,76859215+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c76859215.cost1)
	e1:SetTarget(c76859215.tg1)
	e1:SetOperation(c76859215.op1)
	c:RegisterEffect(e1)
end
function c76859215.cfilter1(c)
	return c:IsSetCard(0x2ca) and c:IsDiscardable()
end
function c76859215.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c76859215.cfilter1,tp,LOCATION_HAND,0,1,c)
	end
	Duel.DiscardHand(tp,c76859215.cfilter1,1,1,REASON_COST+REASON_DISCARD)
end
function c76859215.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c76859215.op1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
