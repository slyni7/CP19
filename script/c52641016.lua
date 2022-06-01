--레미니스 엔드
function c52641016.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,52641016)
    e1:SetCost(c52641016.cost)
    e1:SetTarget(c52641016.target)
    e1:SetOperation(c52641016.activate)
    c:RegisterEffect(e1)
end
function c52641016.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(0x5f1) and c:IsAbleToRemoveAsCost()
end
function c52641016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    if chk==0 then return Duel.IsExistingMatchingCard(c52641016.cfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,c52641016.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
    e:SetLabelObject(g:GetFirst())
end
function c52641016.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
    if chk==0 then
        e:SetLabel(0)
        return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler())
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,e:GetHandler())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c52641016.activate(e,tp,eg,ep,ev,re,r,rp)
     local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
    Duel.Destroy(g,REASON_EFFECT)
end

