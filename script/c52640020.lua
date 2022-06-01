--사이버스 메트로
function c52640020.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,52640020+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c52640020.cost)
    e1:SetTarget(c52640020.target)
    e1:SetOperation(c52640020.activate)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(52640020,0))
    e2:SetCategory(CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,152640020)
    e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c52640020.drcon)
    e2:SetTarget(c52640020.drtg)
    e2:SetOperation(c52640020.drop)
    c:RegisterEffect(e2)
end
function c52640020.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) end
    Duel.PayLPCost(tp,1000)
end
function c52640020.filter(c,e,tp)
    return c:IsRace(RACE_CYBERSE) and c:GetAttack()>=0 and c:GetDefense()>=0 and c:GetAttack()+c:GetDefense()<=2200 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c52640020.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c52640020.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c52640020.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,c52640020.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end

function c52640020.drcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(c52640020.drfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c52640020.drfilter(c)
    return c:IsRace(RACE_CYBERSE) and c:IsAbleToDeck()
end
function c52640020.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
        and Duel.IsExistingMatchingCard(c52640020.drfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
    Duel.SetTargetPlayer(tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c52640020.drop(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
    local g=Duel.GetMatchingGroup(c52640020.drfilter,p,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local sg=g:Select(p,1,1,nil)
    if g:GetCount()>=1 and Duel.SendtoDeck(sg,nil,1,REASON_EFFECT) then
        Duel.ShuffleDeck(p)
        Duel.BreakEffect()
        Duel.Draw(p,1,REASON_EFFECT)
    end
end