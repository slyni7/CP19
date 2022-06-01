--소울차져 버스트
function c52646010.initial_effect(c)
	--발동시 덱에서 마함
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,52646010)
    e1:SetOperation(c52646010.stop)
    c:RegisterEffect(e1)
	--자기 자신 묘지로 보내고 대상찍고 링크마커 세서 그 수만큼 고르고 펑
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,52646990+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c52646010.descost)
    e2:SetTarget(c52646010.destg)
    e2:SetOperation(c52646010.desop)
    c:RegisterEffect(e2)
end
function c52646010.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
    Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c52646010.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f6) and c:IsAbleToGrave() and c:GetOverlayCount()~=0
end
function c52646010.linkfilter(c)
    return c:IsType(TYPE_LINK)
end
function c52646010.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c52646010.filter,tp,LOCATION_MZONE,0,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SelectTarget(tp,c52646010.filter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
end
function c52646010.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget() 
	local g=tc:GetOverlayGroup():Filter(c52646010.linkfilter,nil)
    local ct=g:GetSum(Card.GetLink,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if ct==0 or g==0 then return end
    if dg:GetCount()>0 then
        Duel.HintSelection(dg)
		if Duel.Destroy(dg,REASON_EFFECT) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
		end
    end
end
function c52646010.setfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x5f6) and c:IsSSetable()
end
function c52646010.stop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
    if Duel.SelectYesNo(tp,aux.Stringid(52646010,0)) then
		local g=Duel.SelectMatchingCard(tp,c52646010.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			Duel.SSet(tp,g:GetFirst())
			Duel.ConfirmCards(1-tp,g)
		end
	end
end