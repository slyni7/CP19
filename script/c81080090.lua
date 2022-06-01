--genma : kaimetsu

function c81080090.initial_effect(c)

	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(81080090,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetProperty(EFFECT_TARGET_PLAYER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,81080090+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c81080090.drcs)
	e1:SetTarget(c81080090.drtg)
	e1:SetOperation(c81080090.drop)
	c:RegisterEffect(e1)
end

--drawing
function c81080090.drcsfilter(c)
	return c:IsSetCard(0xcab) and c:IsReleasable() and c:IsType(TYPE_MONSTER)
	and ( ( c:IsFaceup() and c:IsLocation(LOCATION_MZONE) ) or c:IsLocation(LOCATION_HAND) )	
end
function c81080090.drcs(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=LOCATION_HAND+LOCATION_MZONE
	if chk==0 then
		return Duel.IsExistingMatchingCard(c81080090.drcsfilter,tp,loc,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c81080090.drcsfilter,tp,loc,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c81080090.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,2)
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c81080090.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
