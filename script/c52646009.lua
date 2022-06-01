--소울차져 언와인드
function c52646009.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,52646009+EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(c52646009.target)
    e1:SetOperation(c52646009.activate)
    c:RegisterEffect(e1)
end
function c52646009.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f6) and c:IsAbleToGrave() and c:GetOverlayCount()~=0
end
function c52646009.linkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c52646009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c52646009.filter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp) end
	Duel.SelectTarget(tp,c52646009.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local g=c:GetOverlayGroup():Filter(c52646009.linkfilter,nil)
    local ct=g:GetSum(Card.GetLink,nil)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c52646009.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local tc=Duel.GetFirstTarget()  
	local g=tc:GetOverlayGroup():Filter(c52646009.linkfilter,nil)
    local ct=g:GetSum(Card.GetLink,nil)
    if Duel.Draw(p,ct,REASON_EFFECT) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end