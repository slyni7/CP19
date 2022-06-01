--CB(커먼 버그)-디버깅
local m=52649010
local cm=_G["c"..m]
function c52649010.initial_effect(c)
	local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(cm.target)
    e1:SetOperation(cm.activate)
    c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_TOHAND)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
    e2:SetCost(cm.thcost)
    e2:SetTarget(cm.thtg)
    e2:SetOperation(cm.thop)
    c:RegisterEffect(e2)
end
function cm.rsfilter(c,e,tp,rm,ft)
    if not c:IsSetCard(0x5f9) or not c:IsType(TYPE_RITUAL) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
    local mg=rm:Filter(Card.IsCanBeRitualMaterial,c,c)
    if ft>0 then
        return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetOriginalLevel(),c)
    else
        return mg:IsExists(cm.rsfilterF,1,nil,tp,mg,c)
    end
end
function cm.rsfilterF(c,tp,mg,rc)
    if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
        Duel.SetSelectedCard(c)
        return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetOriginalLevel(),rc)
    else return false end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local mg1=Duel.GetRitualMaterial(tp)
		mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        return ft>-1 and Duel.IsExistingMatchingCard(cm.rsfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg1,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end     
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
    local mg1=Duel.GetRitualMaterial(tp)
	mg1:Remove(Card.IsLocation,nil,LOCATION_HAND)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=Duel.SelectMatchingCard(tp,cm.rsfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg1,ft)
    local tc=tg:GetFirst()
    if tc then
        mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
        local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
        tc:SetMaterial(mat)
        Duel.ReleaseRitualMaterial(mat)
        Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
function cm.thfilter(c)
    return c:IsSetCard(0x5f9) and c:IsAbleToRemoveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToHand() end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SendtoHand(c,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,c)
    end
end